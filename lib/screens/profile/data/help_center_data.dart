import 'package:boxicons/boxicons.dart';
import '../models/article_model.dart';
import '../models/faq_model.dart';
import '../models/quick_help_model.dart';

class HelpCenterData {
  static const List<QuickHelpModel> quickHelpItems = [
    QuickHelpModel(title: 'Buy Gift Cards', icon: Boxicons.bx_shopping_bag),
    QuickHelpModel(title: 'Sell Gift Cards', icon: Boxicons.bx_purchase_tag),
    QuickHelpModel(title: 'Wallet', icon: Boxicons.bx_wallet),
    QuickHelpModel(title: 'Withdrawals', icon: Boxicons.bx_money),
    QuickHelpModel(title: 'Security & PIN', icon: Boxicons.bx_check_shield),
    QuickHelpModel(title: 'Account', icon: Boxicons.bx_user),
    QuickHelpModel(title: 'Verification (KYC)', icon: Boxicons.bx_shield_quarter),
    QuickHelpModel(title: 'App Settings', icon: Boxicons.bx_cog),
  ];

  static const List<FAQModel> faqs = [
    FAQModel(
      question: 'How do I buy a gift card?',
      category: 'Buying',
      answer:
          '1. Go to the Cards tab and tap "Buy Gift Cards".\n2. Select your brand (Amazon, Apple, Steam, Netflix, etc.) and country region.\n3. Choose your card amount or enter a custom value.\n4. Review the live exchange rate and select your payment source.\n5. Authorize with your 4-digit PIN or Biometrics.\nYour digital gift card code is delivered instantly on screen and stored in your Orders receipt.',
    ),
    FAQModel(
      question: 'How do I sell a gift card?',
      category: 'Selling',
      answer:
          '1. Tap "Sell Gift Cards" from the home screen or quick actions.\n2. Choose the card brand and currency (USD, GBP, EUR, CAD, AUD, etc.).\n3. Select whether you are submitting an E-Code or a Physical card.\n4. Enter the card value and code (or upload crisp front/back photos).\n5. Review the guaranteed payout amount and tap "Submit Card".\nOur verification team verifies and credits your wallet in 2 to 10 minutes.',
    ),
    FAQModel(
      question: 'Why is my card pending verification?',
      category: 'Selling',
      answer:
          'When you submit a card for sale, our automated balance verification system checks the card with the official issuer to ensure the balance is intact and untampered. Verification typically takes between 2 to 10 minutes. You can track progress in real-time under Orders > Pending.',
    ),
    FAQModel(
      question: 'When will I receive payment?',
      category: 'Wallet',
      answer:
          'Immediately upon card approval! Your payout is credited directly into your NobleCards USD wallet. You can hold your funds, swap currencies, or withdraw directly to your saved bank account 24/7.',
    ),
    FAQModel(
      question: 'How do I change my transaction PIN?',
      category: 'Security',
      answer:
          'Go to Profile > Security & PIN > Change Transaction PIN. Enter your current 4-digit PIN, then enter and confirm your new 4-digit PIN. If you ever forget your PIN, tap "Forgot PIN" on the PIN screen to verify via email OTP.',
    ),
    FAQModel(
      question: 'What are the withdrawal limits and fees?',
      category: 'Withdrawals',
      answer:
          'Daily limits scale with your Account Level (Bronze: \$2,000/day, Silver: \$5,000/day, Gold: \$10,000/day, Platinum: \$25,000/day, Diamond: \$50,000/day). Withdrawal fees are low and shown transparently before you confirm your transfer.',
    ),
    FAQModel(
      question: 'How do I enable Face ID or Fingerprint login?',
      category: 'Security',
      answer:
          'Go to Profile > Biometric Login. You can toggle Biometric Login for instant, passwordless sign-in and Biometric Authorization for transaction PIN confirmations using your device\'s hardware sensor.',
    ),
    FAQModel(
      question: 'What should I do if my card is rejected?',
      category: 'Selling',
      answer:
          'Cards may be rejected if the code has zero balance, is already redeemed, or if physical images are unreadable. You can view the specific rejection reason in your Orders tab by tapping the order card. You can also contact Live Chat for instant review.',
    ),
  ];

  static const List<ArticleModel> popularArticles = [
    ArticleModel(
      title: 'Getting Started with NobleCards',
      subtitle: 'Learn the basics of NobleCards',
      icon: Boxicons.bx_book_open,
      category: 'General',
      readTime: '3 min read',
      content:
          'Welcome to NobleCards! Here is your quick start guide:\n\n'
          '• **Wallet Setup**: Your account comes with a multi-currency wallet with instant USD balances.\n'
          '• **Buying Cards**: Browse thousands of gift cards across multiple countries and receive redemption codes instantly.\n'
          '• **Selling Cards**: Trade unused gift cards for top market rates with fast automated payouts.\n'
          '• **Security**: Protect your funds by setting a 4-digit Transaction PIN and enabling Face ID or Fingerprint login.\n'
          '• **Account Tiers**: Trade more volume to level up from Bronze to Diamond and unlock higher daily withdrawal limits and VIP perks.',
    ),
    ArticleModel(
      title: 'Buying Your First Gift Card',
      subtitle: 'A step-by-step guide to instant codes',
      icon: Boxicons.bx_cart,
      category: 'Buying',
      readTime: '4 min read',
      content:
          'Purchasing gift cards on NobleCards is simple, safe, and instantaneous:\n\n'
          '1. **Select Brand & Region**: Choose from popular brands like Apple, Amazon, Steam, PlayStation, Xbox, and Razer Gold. Make sure the region matches your account location.\n'
          '2. **Choose Denomination**: Select standard presets or enter custom amounts where available.\n'
          '3. **Review & Pay**: Verify the final price, select your payment balance, and confirm with your security PIN.\n'
          '4. **Redeem**: Your digital code and PIN are presented immediately on screen with a single-tap copy button and saved under Orders.',
    ),
    ArticleModel(
      title: 'Selling Gift Cards at Best Rates',
      subtitle: 'How to sell and get instant payout',
      icon: Boxicons.bx_purchase_tag_alt,
      category: 'Selling',
      readTime: '5 min read',
      content:
          'Get the highest value for your gift cards on NobleCards:\n\n'
          '• **Live Market Rates**: Rates fluctuate in real-time based on international market demand. Check the Market Rates tab before trading.\n'
          '• **E-Codes vs Physical**: E-codes are processed via automated API verification within minutes. Physical cards with store receipts often earn premium rates.\n'
          '• **Payout Delivery**: Once approved, funds land directly in your USD wallet with zero delay.',
    ),
    ArticleModel(
      title: 'Selling Physical Cards & Photo Tips',
      subtitle: 'How to submit physical cards cleanly',
      icon: Boxicons.bx_credit_card,
      category: 'Selling',
      readTime: '3 min read',
      content:
          'To ensure your physical cards are verified in under 5 minutes, follow these photography guidelines:\n\n'
          '1. **Clear Lighting**: Place the card on a flat surface with good natural lighting. Avoid heavy shadows or camera glare.\n'
          '2. **All 4 Corners**: Frame the card so all four corners are visible.\n'
          '3. **Legible Code**: Ensure the scratch-off code and serial numbers are sharp and easy to read.\n'
          '4. **Receipts**: If your card requires a receipt, upload a clear photo showing the date, card number, and cash/card payment method.',
    ),
    ArticleModel(
      title: 'Securing Your NobleCards Account',
      subtitle: 'Transaction PIN, Biometrics, and Session safety',
      icon: Boxicons.bx_check_shield,
      category: 'Security',
      readTime: '4 min read',
      content:
          'Your security is our top priority. We recommend following these best practices:\n\n'
          '• **Transaction PIN**: Never share your 4-digit PIN with anyone. NobleCards support will never ask for your PIN or password.\n'
          '• **Biometric Login**: Enable Face ID or Fingerprint authentication in Profile settings for hardware-backed protection.\n'
          '• **Auto-Lock**: Configure Auto-Lock so your app locks automatically when idle.\n'
          '• **Activity Alerts**: Keep notifications enabled to receive real-time alerts for all logins, orders, and withdrawals.',
    ),
    ArticleModel(
      title: 'Bank Accounts & Withdrawals',
      subtitle: 'Supported corridors and payout speeds',
      icon: Boxicons.bx_money,
      category: 'Withdrawals',
      readTime: '3 min read',
      content:
          'Withdrawing funds from NobleCards is effortless:\n\n'
          '• **Instant Processing**: Most bank payouts are processed within 1 to 5 minutes via automated payout gateways.\n'
          '• **Supported Corridors**: We support Nigerian NGN bank transfers, Ghanaian GHS mobile money, UK Faster Payments, and US ACH.\n'
          '• **Saved Accounts**: Save multiple beneficiaries in Profile > Bank Accounts for one-tap withdrawals anytime.',
    ),
  ];

  static const List<ArticleModel> contactSupportItems = [
    ArticleModel(
      title: 'Live Chat',
      subtitle: '24/7 Instant',
      icon: Boxicons.bx_message_rounded_dots,
    ),
    ArticleModel(
      title: 'Email Support',
      subtitle: 'noblecards69@gmail.com',
      icon: Boxicons.bx_envelope,
    ),
    ArticleModel(
      title: 'WhatsApp',
      subtitle: 'Chat Support',
      icon: Boxicons.bxl_whatsapp,
    ),
    ArticleModel(
      title: 'Call Support',
      subtitle: 'VIP Phone Line',
      icon: Boxicons.bx_phone_call,
    ),
  ];
}
