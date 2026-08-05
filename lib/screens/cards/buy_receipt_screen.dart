import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import './models/sell_receipt_model.dart'; // Reusing VerificationStatus enum mapping
import './providers/buy_receipt_provider.dart';
import './widgets/receipt_detail_tile.dart'; // Reused from Sale Receipt
import './widgets/receipt_header.dart'; // Reused from Sale Receipt
import './widgets/receipt_status_banner.dart'; // Reused from Sale Receipt
import './widgets/ready_to_use_info_card.dart';
import 'buy_gift_card_details_screen.dart';

class BuyReceiptScreen extends StatefulWidget {
  final String transactionId;

  const BuyReceiptScreen({super.key, required this.transactionId});

  @override
  State<BuyReceiptScreen> createState() => _BuyReceiptScreenState();
}

class _BuyReceiptScreenState extends State<BuyReceiptScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuyReceiptProvider>().loadReceipt(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Purchase Receipt',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating PDF...'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Boxicons.bx_download, color: AppColors.success, size: 18),
            label: const Text('Download', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<BuyReceiptProvider>(
        builder: (context, provider, child) {
          if (provider.state == BuyReceiptState.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.success));
          }
          if (provider.state == BuyReceiptState.error) {
            return Center(child: Text(provider.errorMessage));
          }

          final data = provider.receipt!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Reusable Ticket Container
                ClipPath(
                  clipper: _TicketTopClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const ReceiptHeader(subtitle: 'GIFT CARD PURCHASE RECEIPT'),
                        const SizedBox(height: 24),
                        
                        // Map PurchaseStatus to VerificationStatus for the reused banner
                        ReceiptStatusBanner(status: VerificationStatus.completed),
                        const SizedBox(height: 24),
                        
                        ReceiptDetailTile(
                          icon: Boxicons.bx_hash,
                          label: 'Reference ID',
                          value: data.referenceId,
                          isHighlighted: true,
                          isGreen: true,
                        ),
                        _buildDivider(isDark),
                        
                        ReceiptDetailTile(
                          icon: Boxicons.bx_credit_card,
                          label: 'Gift Card',
                          customValueWidget: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                                child: const Icon(Boxicons.bxl_amazon, color: Colors.orange, size: 14),
                              ),
                              const SizedBox(width: 6),
                              Text(data.brandName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                        _buildDivider(isDark),

                        ReceiptDetailTile(
                          icon: Boxicons.bx_globe,
                          label: 'Region',
                          customValueWidget: Row(
                            children: [
                              const Text('🇺🇸', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(data.region, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_purchase_tag, label: 'Card Type', value: data.cardType),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_layer, label: 'Quantity', value: '${data.quantity}'),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_dollar_circle, label: 'Face Value', value: '\$${data.faceValue.toStringAsFixed(2)}'),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_wallet, label: 'Amount Paid', value: '\$${data.amountPaid.toStringAsFixed(2)}', isHighlighted: true, isGreen: true),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_credit_card_front, label: 'Payment Method', value: data.paymentMethod),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_calendar, label: 'Purchase Date', value: data.purchaseDate),
                        _buildDivider(isDark),

                        ReceiptDetailTile(
                          icon: Boxicons.bx_check_shield,
                          label: 'Status',
                          customValueWidget: Text(
                            'Completed', 
                            style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                ReadyToUseInfoCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GiftCardDetailsScreen(card: data)),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Primary Button
                _buildActionButton(
                  context,
                  label: 'View Gift Card',
                  icon: Boxicons.bx_credit_card_front,
                  isPrimary: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GiftCardDetailsScreen(card: data)),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // Secondary Button
                _buildActionButton(
                  context,
                  label: 'View Receipt',
                  icon: Boxicons.bx_receipt,
                  isPrimary: false,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Implement PDF Preview logic
                  },
                ),
                const SizedBox(height: 12),
                
                // Ghost Button
                _buildActionButton(
                  context,
                  label: 'Done',
                  icon: Boxicons.bx_check_circle,
                  isPrimary: false,
                  isGhost: true,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), height: 1);
  }

  Widget _buildActionButton(BuildContext context, {
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
    bool isGhost = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isPrimary ? AppColors.success : (isGhost ? Colors.transparent : (isDark ? AppColors.darkCard : AppColors.white));
    final textColor = isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black);
    final borderColor = isPrimary ? Colors.transparent : (isGhost ? (isDark ? Colors.white24 : Colors.black12) : (isDark ? AppColors.darkBorder : AppColors.lightBorder));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      splashColor: isPrimary ? Colors.white24 : AppColors.success.withValues(alpha: 0.1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          ],
        ),
      ),
    );
  }
}

// Reusable Clipper extracted for clean code
class _TicketTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    double punchRadius = 4.0;
    double punchSpacing = 12.0;
    double currentX = size.width;

    while (currentX > 0) {
      currentX -= punchSpacing;
      if (currentX > 0) {
        path.arcToPoint(
          Offset(currentX - punchRadius * 2, 0),
          radius: Radius.circular(punchRadius),
          clockwise: false,
        );
        currentX -= punchRadius * 2;
      }
    }
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}