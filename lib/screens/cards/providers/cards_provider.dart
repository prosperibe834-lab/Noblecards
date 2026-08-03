import 'package:flutter/material.dart';
import '../models/gift_card_model.dart';
import '../services/cards_service.dart';

enum CardsState { loading, loaded, error, empty }

class CardsProvider extends ChangeNotifier {
  final CardsService _service = CardsService();

  CardsState _state = CardsState.loading;
  List<GiftCardModel> _allCards = [];
  List<GiftCardModel> _recentlyViewed = [];

  CardsState get state => _state;
  List<GiftCardModel> get allCards => _allCards;
  List<GiftCardModel> get recentlyViewed => _recentlyViewed;

  CardsProvider() {
    fetchCards();
  }

  Future<void> fetchCards() async {
    _state = CardsState.loading;
    notifyListeners();
    try {
      _allCards = await _service.fetchCards();
      _recentlyViewed = _allCards.take(5).toList();
      _state = _allCards.isEmpty ? CardsState.empty : CardsState.loaded;
    } catch (_) {
      _state = CardsState.error;
    }
    notifyListeners();
  }

  void addRecentlyViewed(GiftCardModel card) {
    _recentlyViewed.removeWhere((element) => element.id == card.id);
    _recentlyViewed.insert(0, card);
    notifyListeners();
  }
}