import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/profile/edit_profile_screen.dart';
import 'package:noble_cards/screens/profile/models/editable_profile_model.dart';
import 'package:noble_cards/screens/profile/providers/edit_profile_provider.dart';
import 'package:noble_cards/screens/profile/services/profile_storage_service.dart';
import 'package:provider/provider.dart';

final _placeholderPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/n7sAAAAASUVORK5CYII=',
);

class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _TestHttpRequest();

  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => _TestHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _TestHttpResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _placeholderPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  String get reasonPhrase => 'OK';

  @override
  HttpHeaders get headers => _TestHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(_placeholderPng).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeProfileStorageService extends ProfileStorageService {
  _FakeProfileStorageService(this.profile);

  EditableProfileModel profile;
  Map<String, dynamic>? lastSavedPayload;
  bool failSave = false;

  @override
  Future<EditableProfileModel> fetchProfile() async => profile;

  @override
  Future<EditableProfileModel> saveProfile(
    EditableProfileModel editedProfile, {
    image,
    bool removeImage = false,
  }) async {
    lastSavedPayload = editedProfile.toApiMap();
    if (failSave) throw Exception('Profile save failed.');
    profile = editedProfile;
    return profile;
  }
}

EditableProfileModel _profile({String dateOfBirth = '12 July 2001'}) =>
    EditableProfileModel(
      fullName: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      phone: '+1234567890',
      country: 'Testland',
      dateOfBirth: dateOfBirth,
      gender: 'Prefer not to say',
      address: 'Test address',
    );

Future<EditProfileProvider> _mountScreen(
  WidgetTester tester,
  _FakeProfileStorageService storage,
) async => HttpOverrides.runZoned(() async {
  final provider = EditProfileProvider(storageService: storage);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(home: EditProfileScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return provider;
}, createHttpClient: (_) => _TestHttpClient());

Finder _dateOfBirthField() => find.byWidgetPredicate(
  (widget) => widget is TextFormField && widget.controller?.text.contains('July') == true,
);

void main() {
  test('date-only API serialization and profile refresh preserve the calendar day', () {
    final refreshed = EditableProfileModel.fromMap({
      'dateOfBirth': '2001-07-12T00:00:00.000Z',
    });

    expect(refreshed.dateOfBirth, '12 July 2001');
    expect(refreshed.toApiMap()['dateOfBirth'], '2001-07-12');
  });

  testWidgets('date picker selection updates and saves without a build-phase assertion', (tester) async {
    final storage = _FakeProfileStorageService(_profile());
    final provider = await _mountScreen(tester, storage);
    addTearDown(provider.dispose);

    final field = _dateOfBirthField();
    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('13').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(provider.profile.dateOfBirth, '13 July 2001');
    expect(_dateOfBirthField(), findsOneWidget);

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(storage.lastSavedPayload?['dateOfBirth'], '2001-07-13');
    expect(storage.profile.dateOfBirth, '13 July 2001');
    expect(provider.hasChanges, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelling date selection leaves the saved value unchanged', (tester) async {
    final storage = _FakeProfileStorageService(_profile());
    final provider = await _mountScreen(tester, storage);
    addTearDown(provider.dispose);

    final field = _dateOfBirthField();
    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is Text && widget.data?.toLowerCase() == 'cancel',
    ));
    await tester.pumpAndSettle();

    expect(provider.profile.dateOfBirth, '12 July 2001');
    expect(provider.hasChanges, isFalse);
    expect(tester.takeException(), isNull);
  });

  test('failed saves do not replace the previously saved date', () async {
    final storage = _FakeProfileStorageService(_profile())..failSave = true;
    final provider = EditProfileProvider(storageService: storage);
    addTearDown(provider.dispose);

    await provider.loadProfileData();
    provider.updateDateOfBirth('13 July 2001');

    expect(await provider.saveChanges(), isFalse);
    expect(storage.profile.dateOfBirth, '12 July 2001');
    expect(provider.errorMessage, 'Profile save failed.');
  });
}