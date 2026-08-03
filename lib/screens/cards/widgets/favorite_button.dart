import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  final String cardId;

  const FavoriteButton({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(cardId);

    return GestureDetector(
      onTap: () => favProvider.toggleFavorite(cardId),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFav),
          size: 20,
          color: isFav ? AppColors.error : AppColors.lightSubText,
        ),
      ),
    );
  }
}