import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import './providers/submission_provider.dart';
import './widgets/action_buttons_section.dart';
import './widgets/animated_submission_success.dart';
import './widgets/notification_info_card.dart';
import './widgets/submission_status_card.dart';
import './widgets/submission_summary_card.dart';

class GiftcardSubmissionReceivedScreen extends StatefulWidget {
  final String transactionId;

  const GiftcardSubmissionReceivedScreen({super.key, required this.transactionId});

  @override
  State<GiftcardSubmissionReceivedScreen> createState() => _GiftcardSubmissionReceivedScreenState();
}

class _GiftcardSubmissionReceivedScreenState extends State<GiftcardSubmissionReceivedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmissionProvider>().fetchDetails(widget.transactionId);
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
          'Submission Received',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Consumer<SubmissionProvider>(
        builder: (context, provider, child) {
          if (provider.state == SubmissionState.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.success));
          }

          if (provider.state == SubmissionState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text('Failed to load submission details'),
                  TextButton(
                    onPressed: () => provider.fetchDetails(widget.transactionId),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          final data = provider.submissionData!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AnimatedSubmissionSuccess(),
                const SizedBox(height: 24),
                Text(
                  'Submission Received!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your gift cards have been successfully submitted.\nOur team is now verifying your cards.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
                const SizedBox(height: 20),
                const SubmissionStatusCard(),
                const SizedBox(height: 30),
                SubmissionSummaryCard(data: data),
                const SizedBox(height: 16),
                const NotificationInfoCard(),
                const SizedBox(height: 32),
                const ActionButtonsSection(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}