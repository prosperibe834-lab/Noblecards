import 'package:boxicons/boxicons.dart';
import '../models/quick_action.dart';

class ChatDemoService {
  static List<QuickAction> getPopularIssues() {
    return [
      QuickAction(
        title: 'Buy Gift Card',
        subtitle: 'Issues with purchased gift cards',
        icon: Boxicons.bx_shopping_bag,
        autoMessage: 'Hello 👋\n\nThanks for contacting NobleCards Support.\nPlease provide:\n• Order ID\n• Gift Card Name\n• Amount\n• Explain the issue\n\nYou can also attach screenshots below.',
      ),
      QuickAction(
        title: 'Sell Gift Card',
        subtitle: 'Issues with selling gift cards',
        icon: Boxicons.bx_credit_card,
        autoMessage: 'Hello 👋\n\nPlease send:\n• Submission ID\n• Gift Card Name\n• Card Value\n• Describe the issue',
      ),
      QuickAction(
        title: 'Wallet & Deposit',
        subtitle: 'Deposit or balance issues',
        icon: Boxicons.bx_wallet,
        autoMessage: 'Please provide:\nDeposit ID\nPayment Method\nAmount',
      ),
      QuickAction(
        title: 'Withdrawal',
        subtitle: 'Withdrawal or payout issues',
        icon: Boxicons.bx_money,
        autoMessage: 'Please provide:\nWithdrawal ID\nAmount\nWallet/Currency',
      ),
      QuickAction(
        title: 'Payments',
        subtitle: 'Payment failures or deductions',
        icon: Boxicons.bx_credit_card_front,
        autoMessage: 'Please provide your transaction ID and details of the payment failure.',
      ),
      QuickAction(
        title: 'Verification (KYC)',
        subtitle: 'Verification or KYC issues',
        icon: Boxicons.bx_check_shield,
        autoMessage: 'Please send your Submission ID.\nWe\'ll check the verification progress.',
      ),
      QuickAction(
        title: 'Security',
        subtitle: 'Account security & access issues',
        icon: Boxicons.bx_lock_alt,
        autoMessage: 'Describe your login or security problem in detail.',
      ),
      QuickAction(
        title: 'Report Scam',
        subtitle: 'Report scam or suspicious activity',
        icon: Boxicons.bx_error,
        autoMessage: 'Please provide details of the suspicious activity, including usernames or transaction IDs.',
      ),
      QuickAction(
        title: 'Other Issues',
        subtitle: 'Other issues not listed above',
        icon: Boxicons.bx_dots_horizontal_rounded,
        autoMessage: 'How can we help you today? Please describe your issue.',
      ),
    ];
  }
}