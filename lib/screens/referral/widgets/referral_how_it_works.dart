import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReferralHowItWorks extends StatelessWidget {
  const ReferralHowItWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final iconBgColor = isDark ? const Color(0xFF233026) : const Color(0xFFE8F6ED);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Boxicons.bx_shield_quarter, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStep(
                context: context,
                number: '1',
                icon: Boxicons.bx_user_plus,
                title: 'They Join',
                desc: 'Your friend signs up using your referral link',
                iconBgColor: iconBgColor,
              ),
              _buildDottedLine(isDark),
              _buildStep(
                context: context,
                number: '2',
                icon: Boxicons.bx_wallet,
                title: 'First Deposit',
                desc: 'They make their first successful deposit',
                iconBgColor: iconBgColor,
              ),
              _buildDottedLine(isDark),
              _buildStep(
                context: context,
                number: '3',
                icon: Boxicons.bx_gift,
                title: 'You Earn',
                desc: 'They buy a gift card worth at least 10% of their deposit. You earn 1.5%',
                iconBgColor: iconBgColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required String number,
    required IconData icon,
    required String title,
    required String desc,
    required Color iconBgColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF00B94A), size: 18),
              ),
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00B94A),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine(bool isDark) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}