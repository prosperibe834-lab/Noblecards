// Location: lib/deposit/widgets/bank_transfer_shimmer.dart
import 'package:flutter/material.dart';

class BankTransferShimmer extends StatefulWidget {
  final bool isDark;

  const BankTransferShimmer({super.key, required this.isDark});

  @override
  State<BankTransferShimmer> createState() => _BankTransferShimmerState();
}

class _BankTransferShimmerState extends State<BankTransferShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final highlightColor = widget.isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F5F9);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Step indicator shimmer
              _buildShimmerBox(width: double.infinity, height: 26, baseColor: baseColor, highlightColor: highlightColor, radius: 13),
              const SizedBox(height: 20),

              // Banner Card shimmer
              _buildShimmerBox(width: double.infinity, height: 130, baseColor: baseColor, highlightColor: highlightColor, radius: 22),
              const SizedBox(height: 24),

              // Section Title shimmer
              _buildShimmerBox(width: 140, height: 20, baseColor: baseColor, highlightColor: highlightColor, radius: 6),
              const SizedBox(height: 14),

              // Transfer Details Card shimmer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF13222E) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: widget.isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildShimmerBox(width: 42, height: 42, baseColor: baseColor, highlightColor: highlightColor, radius: 21),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerBox(width: 110, height: 16, baseColor: baseColor, highlightColor: highlightColor, radius: 4),
                            const SizedBox(height: 6),
                            _buildShimmerBox(width: 140, height: 12, baseColor: baseColor, highlightColor: highlightColor, radius: 4),
                          ],
                        ),
                        const Spacer(),
                        _buildShimmerBox(width: 60, height: 24, baseColor: baseColor, highlightColor: highlightColor, radius: 12),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1),
                    const SizedBox(height: 18),
                    _buildRowShimmer(baseColor, highlightColor),
                    const SizedBox(height: 16),
                    _buildRowShimmer(baseColor, highlightColor),
                    const SizedBox(height: 16),
                    _buildRowShimmer(baseColor, highlightColor),
                    const SizedBox(height: 16),
                    _buildRowShimmer(baseColor, highlightColor),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Timer Card shimmer
              _buildShimmerBox(width: double.infinity, height: 68, baseColor: baseColor, highlightColor: highlightColor, radius: 16),
              const SizedBox(height: 16),

              // Note shimmer
              _buildShimmerBox(width: double.infinity, height: 56, baseColor: baseColor, highlightColor: highlightColor, radius: 14),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowShimmer(Color baseColor, Color highlightColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildShimmerBox(width: 90, height: 14, baseColor: baseColor, highlightColor: highlightColor, radius: 4),
        _buildShimmerBox(width: 130, height: 14, baseColor: baseColor, highlightColor: highlightColor, radius: 4),
      ],
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: [
            (_controller.value - 0.3).clamp(0.0, 1.0),
            _controller.value,
            (_controller.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}
