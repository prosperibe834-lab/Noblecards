import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadow.dart';
import '../../theme/app_spacing.dart';

import 'providers/create_pin_provider.dart';
import 'widgets/create_pin_header.dart';
import 'widgets/security_illustration.dart';
import 'widgets/pin_input_display.dart';
import 'widgets/pin_requirements.dart';
import 'widgets/custom_keypad.dart';
import 'widgets/success_modal.dart';

class CreatePinScreen extends StatelessWidget {
  const CreatePinScreen({super.key});

  void _handleContinue(BuildContext context) async {
    final provider = context.read<CreatePinProvider>();
    final success = await provider.submitPin();

    if (success && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            SuccessModal(onDone: () => Navigator.of(context).pop(true)),
      );
    } else if (context.mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreatePinProvider(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const CreatePinHeader(),
                        const SizedBox(height: AppSpacing.lg),
                        const SecurityIllustration(),
                        const SizedBox(height: AppSpacing.lg),

                        // Titles
                        Text(
                          'Create 4-Digit\nTransaction PIN',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'This PIN will be used to authorize\nyour transactions securely.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: AppSpacing.xl),
                        const PinInputDisplay(),
                        const SizedBox(height: AppSpacing.xl),

                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: PinRequirements(),
                        ),

                        const Spacer(), // Pushes Keypad & Continue button to the bottom

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.md,
                          ),
                          child: Consumer<CreatePinProvider>(
                            builder: (context, provider, child) {
                              return Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                  boxShadow: provider.isComplete
                                      ? AppShadow.light
                                      : [],
                                  gradient: provider.isComplete
                                      ? const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primaryDark,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : null,
                                  color: provider.isComplete
                                      ? null
                                      : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.lg,
                                    ),
                                    onTap:
                                        provider.isComplete &&
                                            !provider.isLoading
                                        ? () => _handleContinue(context)
                                        : null,
                                    child: Center(
                                      child: provider.isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: AppColors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Continue',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color:
                                                            provider.isComplete
                                                            ? AppColors.white
                                                            : (Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? AppColors
                                                                        .darkSubText
                                                                  : AppColors
                                                                        .lightSubText),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  width: AppSpacing.sm,
                                                ),
                                                Icon(
                                                  Boxicons.bx_right_arrow_alt,
                                                  color: provider.isComplete
                                                      ? AppColors.white
                                                      : (Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? AppColors
                                                                  .darkSubText
                                                            : AppColors
                                                                  .lightSubText),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const CustomKeypad(),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
