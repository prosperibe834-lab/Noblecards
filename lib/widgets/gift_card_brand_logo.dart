import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';

class GiftCardBrandLogo extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color fallbackColor;

  const GiftCardBrandLogo({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    final uri = imageUrl == null ? null : Uri.tryParse(imageUrl!);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return _fallback();
    }

    return Image.network(
      uri.toString(),
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _fallback() => Icon(
    Boxicons.bx_credit_card_front,
    key: const ValueKey('gift-card-brand-fallback'),
    color: fallbackColor,
    size: size,
  );
}
