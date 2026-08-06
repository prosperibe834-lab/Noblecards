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
    FAQModel(question: 'How do I buy a gift card?', answer: ''),
    FAQModel(question: 'How do I sell a gift card?', answer: ''),
    FAQModel(question: 'Why is my card pending verification?', answer: ''),
    FAQModel(question: 'When will I receive payment?', answer: ''),
    FAQModel(question: 'How do I change my transaction PIN?', answer: ''),
  ];

  static const List<ArticleModel> popularArticles = [
    ArticleModel(
      title: 'Getting Started',
      subtitle: 'Learn the basics of NobleCards',
      icon: Boxicons.bx_book_open,
    ),
    ArticleModel(
      title: 'Buying Your First Gift Card',
      subtitle: 'A step-by-step guide',
      icon: Boxicons.bx_cart,
    ),
    ArticleModel(
      title: 'Selling Gift Cards',
      subtitle: 'How to sell your gift cards',
      icon: Boxicons.bx_purchase_tag_alt,
    ),
    ArticleModel(
      title: 'Selling Physical Cards',
      subtitle: 'How to submit physical cards',
      icon: Boxicons.bx_credit_card,
    ),
  ];

  static const List<ArticleModel> contactSupportItems = [
    ArticleModel(title: 'Live Chat', subtitle: 'Chat with us', icon: Boxicons.bx_message_rounded_dots),
    ArticleModel(title: 'Email Support', subtitle: 'Send us email', icon: Boxicons.bx_envelope),
    ArticleModel(title: 'WhatsApp', subtitle: 'Chat on WhatsApp', icon: Boxicons.bxl_whatsapp),
    ArticleModel(title: 'Call Support', subtitle: 'Talk to us', icon: Boxicons.bx_phone_call),
  ];
}