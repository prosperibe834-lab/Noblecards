import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String cardId) => _favoriteIds.contains(cardId);

  void toggleFavorite(String cardId) {
    if (_favoriteIds.contains(cardId)) {
      _favoriteIds.remove(cardId);
    } else {
      _favoriteIds.add(cardId);
    }
    notifyListeners();
  }
}