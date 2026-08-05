import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import 'models/order_model.dart';
import 'services/order_filter_service.dart';
import 'widgets/order_card.dart';
import 'widgets/order_empty_widget.dart';
import 'widgets/order_search_bar.dart';
import 'widgets/order_shimmer.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/orders_filter_bottom_sheet.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<OrderModel> _allOrders = [];
  bool _isLoading = true;
  String _activeChip = 'All';

  // Bottom sheet filters
  OrderStatus? _filterStatus;
  TransactionType? _filterType;
  String? _filterGiftCard;
  String? _filterSortBy = 'Newest';

  final List<String> _chips = ['All', 'Buy', 'Sell', 'Pending', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API response
    setState(() {
      _allOrders = OrderModel.sampleOrders;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _activeChip = 'All';
      _searchController.clear();
      _filterStatus = null;
      _filterType = null;
      _filterGiftCard = null;
      _filterSortBy = 'Newest';
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrdersFilterBottomSheet(
        initialStatus: _filterStatus,
        initialType: _filterType,
        initialGiftCard: _filterGiftCard,
        initialSort: _filterSortBy,
        onApply: (status, type, card, sort) {
          setState(() {
            _filterStatus = status;
            _filterType = type;
            _filterGiftCard = card;
            _filterSortBy = sort;
          });
        },
        onReset: _resetFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredOrders = OrderFilterService.filterOrders(
      orders: _allOrders,
      chipFilter: _activeChip,
      searchQuery: _searchController.text,
      status: _filterStatus,
      type: _filterType,
      giftCard: _filterGiftCard,
      sortBy: _filterSortBy,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadOrders,
          color: AppColors.success,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // Header Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Orders',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : Colors.black,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Track all your gift card transactions',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                                ),
                              ),
                            ],
                          ),
                          // Filter Button
                          InkWell(
                            onTap: _openFilterBottomSheet,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.white,
                                borderRadius: BorderRadius.circular(AppRadius.full),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Boxicons.bx_filter_alt,
                                    size: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),

                      // Animated Summary Cards
                      OrderSummaryCard(orders: _allOrders),

                      const SizedBox(height: 20),

                      // Filter Chips Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _chips.map((chip) {
                            final isSelected = _activeChip == chip;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(chip),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => _activeChip = chip);
                                },
                                selectedColor: AppColors.success,
                                backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Search Field
                      OrderSearchBar(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        onClear: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Content Sliver
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: OrderShimmer(),
                  ),
                )
              else if (filteredOrders.isEmpty)
                SliverToBoxAdapter(
                  child: OrderEmptyWidget(
                    onGoToMarketplace: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return OrderCard(order: filteredOrders[index]);
                      },
                      childCount: filteredOrders.length,
                    ),
                  ),
                ),

              // Bottom Security Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.success.withOpacity(0.08) : AppColors.success.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.success.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Boxicons.bx_shield_quarter, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure & Fast',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'All transactions are encrypted and 100% secure.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Boxicons.bx_gift, color: AppColors.success, size: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}