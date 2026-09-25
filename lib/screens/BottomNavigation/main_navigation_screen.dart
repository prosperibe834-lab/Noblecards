import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../cards/cards_screen.dart';
import '../wallet_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import 'custom_bottom_nav.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToCards: () => _changeTab(1)),
      const CardsScreen(),
      const WalletScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
