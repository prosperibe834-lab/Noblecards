import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import './../../../theme/app_radius.dart';
import './models/sell_receipt_model.dart';
import './providers/sell_receipt_provider.dart';
import './widgets/download_receipt_button.dart';
import './widgets/receipt_detail_tile.dart';
import './widgets/receipt_footer_card.dart';
import './widgets/receipt_header.dart';
import './widgets/receipt_status_banner.dart';

class SellReceiptScreen extends StatefulWidget {
  final String transactionId;

  const SellReceiptScreen({super.key, required this.transactionId});

  @override
  State<SellReceiptScreen> createState() => _SellReceiptScreenState();
}

class _SellReceiptScreenState extends State<SellReceiptScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellReceiptProvider>().loadReceipt(widget.transactionId);
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
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Submission Receipt',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing receipt...'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Boxicons.bx_download, color: AppColors.success, size: 18),
            label: const Text('Download', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<SellReceiptProvider>(
        builder: (context, provider, child) {
          if (provider.state == ReceiptState.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.success));
          }
          if (provider.state == ReceiptState.error) {
            return Center(child: Text(provider.errorMessage));
          }

          final data = provider.receipt!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Top Receipt Card with Perforated Edge
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
                        const ReceiptHeader(),
                        const SizedBox(height: 24),
                        ReceiptStatusBanner(status: data.status),
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
                              Text(data.giftCardName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
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

                        ReceiptDetailTile(icon: Boxicons.bx_layer, label: 'Cards Submitted', value: '${data.cardsSubmitted}'),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_dollar_circle, label: 'Total Face Value', value: '\$${data.totalFaceValue.toStringAsFixed(2)}'),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_line_chart, label: 'Sell Rate', value: '${data.sellRate.toStringAsFixed(2)}%', isHighlighted: true, isGreen: true),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_wallet, label: 'Estimated You Receive', value: '\$${data.estimatedReceive.toStringAsFixed(2)}', isHighlighted: true, isGreen: true),
                        _buildDivider(isDark),

                        ReceiptDetailTile(
                          icon: Boxicons.bx_check_shield,
                          label: 'Verification Status',
                          customValueWidget: _buildStatusChip(data.status),
                        ),
                        _buildDivider(isDark),

                        ReceiptDetailTile(icon: Boxicons.bx_calendar, label: 'Submitted On', value: data.submittedOn),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                const ReceiptFooterCard(),
                const SizedBox(height: 32),
                const DownloadReceiptButton(),
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

  Widget _buildStatusChip(VerificationStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case VerificationStatus.approved:
        bgColor = Colors.green.withValues(alpha: 0.15); textColor = Colors.green; text = 'Approved'; break;
      case VerificationStatus.rejected:
        bgColor = Colors.red.withValues(alpha: 0.15); textColor = Colors.red; text = 'Rejected'; break;
      case VerificationStatus.needsReview:
        bgColor = Colors.blue.withValues(alpha: 0.15); textColor = Colors.blue; text = 'Needs Review'; break;
      case VerificationStatus.pending:
      default:
        bgColor = Colors.orange.withValues(alpha: 0.15); textColor = Colors.orange; text = 'Pending'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

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