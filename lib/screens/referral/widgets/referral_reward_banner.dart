import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReferralRewardBanner extends StatelessWidget {
  const ReferralRewardBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1B2A20) : const Color(0xFFF1F9F3);
    final borderColor = isDark ? const Color(0xFF263C2E) : const Color(0xFFE0EFE5);
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use your referral credit to buy any gift card',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B94A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: Connect this to the Cards screen route
                    // Navigator.pushNamed(context, '/cards');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Browse Gift Cards', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Boxicons.bx_right_arrow_alt, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Fallback Gift Card Graphic Placeholder
          SizedBox(
            width: 80,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text('a', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 5,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Icon(Boxicons.bxl_play_store, color: Colors.blue[400], size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}