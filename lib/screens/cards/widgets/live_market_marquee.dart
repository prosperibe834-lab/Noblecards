import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/live_market_model.dart';
import '../services/live_market_service.dart';

class LiveMarketMarquee extends StatefulWidget {
  const LiveMarketMarquee({super.key});

  @override
  State<LiveMarketMarquee> createState() => _LiveMarketMarqueeState();
}

class _LiveMarketMarqueeState extends State<LiveMarketMarquee> {
  final ScrollController _scrollController = ScrollController();
  final LiveMarketService _service = LiveMarketService();
  List<LiveMarketModel> _items = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _items = await _service.fetchLiveMarketEvents();
    if (mounted) {
      setState(() {});
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_scrollController.hasClients) {
        double maxExtent = _scrollController.position.maxScrollExtent;
        double currentOffset = _scrollController.offset;
        if (currentOffset >= maxExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentOffset + 2.0,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _items.length * 20, // Infinite marquee simulation
        itemBuilder: (context, index) {
          final item = _items[index % _items.length];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(item.logoUrl, width: 14, height: 14, errorBuilder: (_, __, ___) => const Icon(Icons.credit_card, size: 14)),
                const SizedBox(width: 6),
                Text(
                  '${item.cardName} (${item.countryFlag}) ${item.actionType} ${item.timeAgo}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}