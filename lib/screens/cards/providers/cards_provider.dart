import 'package:flutter/material.dart';
import '../models/gift_card_model.dart';
import '../services/cards_service.dart';

enum CardsState { loading, loaded, error, empty }

class CardsProvider extends ChangeNotifier {
  CardsProvider({String? initialCountryCode})
    : _initialCountryCode = initialCountryCode {
    fetchCards(countryCode: initialCountryCode);
  }

  final CardsService _service = CardsService();
  final String? _initialCountryCode;
  final _cachedCards = <String, List<GiftCardModel>>{};
  final _requests = <String, Future<List<GiftCardModel>>>{};

  CardsState _state = CardsState.loading;
  List<GiftCardModel> _allCards = [];
  List<GiftCardModel> _recentlyViewed = [];

  CardsState get state => _state;
  List<GiftCardModel> get allCards => _allCards;
  List<GiftCardModel> get recentlyViewed => _recentlyViewed;

  Future<void> fetchCards({
    String? countryCode,
    bool forceRefresh = false,
  }) async {
    final cacheKey = countryCode ?? 'all';
    final cached = _cachedCards[cacheKey];
    if (!forceRefresh && cached != null) {
      _applyCards(cacheKey, cached);
      return;
    }

    final inFlight = _requests[cacheKey];
    if (inFlight != null) {
      final cards = await inFlight;
      _applyCards(cacheKey, cards);
      return;
    }

    _state = CardsState.loading;
    notifyListeners();

    final request = _service.fetchCards(countryCode: countryCode);
    _requests[cacheKey] = request;
    try {
      final cards = await request;
      _cachedCards[cacheKey] = cards;
      _applyCards(cacheKey, cards);
    } catch (_) {
      _state = CardsState.error;
      notifyListeners();
    } finally {
      _requests.remove(cacheKey);
    }
  }

  void _applyCards(String cacheKey, List<GiftCardModel> cards) {
    _allCards = cards;
    if (cacheKey == (_initialCountryCode ?? 'all')) {
      _recentlyViewed = _allCards.take(5).toList();
    }
    _state = _allCards.isEmpty ? CardsState.empty : CardsState.loaded;
    notifyListeners();
  }

  void addRecentlyViewed(GiftCardModel card) {
    _recentlyViewed.removeWhere((element) => element.id == card.id);
    _recentlyViewed.insert(0, card);
    notifyListeners();
  }
}
