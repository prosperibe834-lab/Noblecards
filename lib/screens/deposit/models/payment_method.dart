// Location: lib/deposit/models/payment_method.dart
import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final bool isRecommended;

  const PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.isRecommended = false,
  });
}

// These match the reference image exactly. 
// In a real app, this might come from an API or configuration file.
final List<PaymentMethod> supportedPaymentMethods = [
  const PaymentMethod(
    id: 'bank_transfer',
    title: 'Local Bank Transfer',
    subtitle: 'Free & Instant',
    icon: Icons.account_balance, // Boxicons bx-building-house equivalent
    iconBackgroundColor: Color(0xFF10B981), // AppColors.primary
    iconColor: Colors.white,
    isRecommended: true,
  ),
  const PaymentMethod(
    id: 'card',
    title: 'Debit or Credit Card',
    subtitle: 'Visa, MasterCard, Verve, Amex',
    icon: Icons.credit_card, // Boxicons bx-credit-card equivalent
    iconBackgroundColor: Color(0xFF2563EB), // AppColors.secondary
    iconColor: Colors.white,
  ),
  const PaymentMethod(
    id: 'mobile_wallet',
    title: 'Apple Pay / Google Pay',
    subtitle: 'Fast checkout via mobile wallet',
    icon: Icons.apple, // Boxicons bxl-apple equivalent
    iconBackgroundColor: Color(0xFF8B5CF6), // AppColors.accentViolet
    iconColor: Colors.white,
  ),
  const PaymentMethod(
    id: 'wire_transfer',
    title: 'Wise / Wire Transfer',
    subtitle: 'International bank wire transfer',
    icon: Icons.public, // Boxicons bx-globe equivalent
    iconBackgroundColor: Color(0xFF6366F1), // Indigo shade for variation
    iconColor: Colors.white,
  ),
];
