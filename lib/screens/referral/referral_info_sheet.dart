import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReferralInfoSheet extends StatelessWidget {
  const ReferralInfoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1D21) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'How NobleCards Referral\nRewards Work',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                    ),
                    child: Icon(Boxicons.bx_x, size: 20, color: textColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_user_plus,
                  number: '1',
                  title: 'Invite friends',
                  description:
                      "Share your unique referral link or QR code.\nYour friend must sign up using your referral link.",
                ),
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_wallet,
                  number: '2',
                  title: 'First deposit',
                  description:
                      "You earn 1.5% of your friend's first qualifying deposit. Only the first deposit counts. Any later deposits by the same person do not generate another referral reward.",
                  highlight: '1.5%',
                ),
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_shopping_bag,
                  number: '3',
                  title: 'Gift card purchase requirement',
                  description:
                      "Your referral reward becomes available only after your referred user completes a qualifying gift-card purchase. The purchase must be at least 10% of their qualifying first deposit.\nExample: If they deposit \$100, they must purchase a gift card worth \$10 or more.",
                  highlight: '10%',
                  highlight2: '\$10 or more.',
                ),
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_gift,
                  number: '4',
                  title: 'Reward usage',
                  description:
                      "Referral rewards are initially restricted to gift-card purchases. Users cannot immediately withdraw referral rewards as cash. The reward can be used to purchase any eligible gift card on NobleCards.",
                ),
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_hide,
                  number: '5',
                  title: 'What you can see',
                  description:
                      "You can see who you referred, their referral status, and your earned rewards. You will not see their private deposit amount or purchase amount.",
                ),
                _buildRuleItem(
                  context: context,
                  icon: Boxicons.bx_shield_quarter,
                  number: '6',
                  title: 'Important',
                  description:
                      "Self-referrals, fake accounts, duplicate accounts, or fraudulent activity don't qualify. NobleCards may review suspicious referral activity before releasing rewards.",
                ),
                const SizedBox(height: 16),
                _buildExampleBox(isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B94A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem({
    required BuildContext context,
    required IconData icon,
    required String number,
    required String title,
    required String description,
    String? highlight,
    String? highlight2,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final iconBgColor = isDark ? const Color(0xFF233026) : const Color(0xFFE8F6ED);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(icon, color: const Color(0xFF00B94A), size: 24),
                ),
                Positioned(
                  top: -6,
                  right: -6,
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
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _buildHighlightedText(description, subTextColor!, highlight, highlight2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
      String text, Color baseColor, String? highlight1, String? highlight2) {
    List<TextSpan> spans = [];
    String remainingText = text;

    void processHighlight(String highlight) {
      if (remainingText.contains(highlight)) {
        int index = remainingText.indexOf(highlight);
        if (index > 0) {
          spans.add(TextSpan(text: remainingText.substring(0, index)));
        }
        spans.add(TextSpan(
          text: highlight,
          style: const TextStyle(
              color: Color(0xFF00B94A), fontWeight: FontWeight.bold),
        ));
        remainingText = remainingText.substring(index + highlight.length);
      }
    }

    if (highlight1 != null) processHighlight(highlight1);
    if (highlight2 != null) processHighlight(highlight2);

    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: baseColor, fontSize: 13, height: 1.4),
        children: spans,
      ),
    );
  }

  Widget _buildExampleBox(bool isDark) {
    final bgColor = isDark ? const Color(0xFF1B2A20) : const Color(0xFFF1F9F3);
    final borderColor = isDark ? const Color(0xFF263C2E) : const Color(0xFFE0EFE5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Boxicons.bx_bulb, color: const Color(0xFF00B94A), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                    children: const [
                      TextSpan(text: 'You invite John → John deposits '),
                      TextSpan(
                          text: '\$100',
                          style: TextStyle(
                              color: Color(0xFF00B94A),
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: ' → John buys a '),
                      TextSpan(
                          text: '\$10',
                          style: TextStyle(
                              color: Color(0xFF00B94A),
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: ' gift card → you earn '),
                      TextSpan(
                          text: '1.5%',
                          style: TextStyle(
                              color: Color(0xFF00B94A),
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: ' of John\'s first deposit = '),
                      TextSpan(
                          text: '\$1.50.',
                          style: TextStyle(
                              color: Color(0xFF00B94A),
                              fontWeight: FontWeight.bold)),
                    ],
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