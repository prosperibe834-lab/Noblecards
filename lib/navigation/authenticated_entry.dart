import 'package:flutter/material.dart';

import '../screens/authentication/services/authentication_service.dart';
import '../screens/createPin/create_pin_screen.dart';

Future<void> navigateAfterAuthentication(
  BuildContext context, {
  required WidgetBuilder destinationBuilder,
}) async {
  final authService = AuthenticationService();
  final hasTransactionPin = await authService.hasTransactionPin();
  if (!context.mounted) return;

  if (!hasTransactionPin) {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const _RequiredCreatePinScreen()),
    );
    if (!context.mounted || created != true) return;
  }

  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: destinationBuilder),
    (_) => false,
  );
}

class AuthenticatedEntryScreen extends StatefulWidget {
  final WidgetBuilder destinationBuilder;

  const AuthenticatedEntryScreen({super.key, required this.destinationBuilder});

  @override
  State<AuthenticatedEntryScreen> createState() =>
      _AuthenticatedEntryScreenState();
}

class _AuthenticatedEntryScreenState extends State<AuthenticatedEntryScreen> {
  @override
  void initState() {
    super.initState();
    _openDestination();
  }

  Future<void> _openDestination() async {
    final authService = AuthenticationService();
    final hasTransactionPin = await authService.hasTransactionPin();
    if (!mounted) return;

    if (!hasTransactionPin) {
      final created = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const _RequiredCreatePinScreen()),
      );
      if (!mounted || created != true) return;
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: widget.destinationBuilder));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _RequiredCreatePinScreen extends StatelessWidget {
  const _RequiredCreatePinScreen();

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: const CreatePinScreen());
  }
}
