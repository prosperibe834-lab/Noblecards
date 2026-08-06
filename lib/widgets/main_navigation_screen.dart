import 'package:flutter/material.dart';
import 'package:noble_cards/widgets/custom_bottom_nav.dart';
import 'package:noble_cards/screens/home_screen.dart';
import 'package:noble_cards/screens/cards/cards_screen.dart';
import 'package:noble_cards/screens/wallet_screen.dart';
import 'package:noble_cards/screens/orders/orders_screen.dart';
import 'package:noble_cards/screens/profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentTab = 0;

  void _changeTab(int index) {
    setState(() => _currentTab = index);
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
      body: IndexedStack(index: _currentTab, children: screens),
      bottomNavigationBar: CustomBottomNav(
        currentTab: _currentTab,
        onTabSelected: _changeTab,
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen")),
    );
  }
}
