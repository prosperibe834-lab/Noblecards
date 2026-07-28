import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsLineChartCard extends StatefulWidget {
  const AnalyticsLineChartCard({Key? key}) : super(key: key);

  @override
  State<AnalyticsLineChartCard> createState() => _AnalyticsLineChartCardState();
}

class _AnalyticsLineChartCardState extends State<AnalyticsLineChartCard> {
  int _selectedTab = 0; // 0: Daily, 1: Weekly, 2: Monthly

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _legendDot('Income', AppColors.success),
                  const SizedBox(width: AppSpacing.m),
                  _legendDot('Expenses', AppColors.error),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _subTab('D', 0),
                    _subTab('W', 1),
                    _subTab('M', 2),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSpacing.l),

          // Custom Line Chart Painter
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(
                isDark: isDark,
                incomePoints: [0.2, 0.45, 0.35, 0.8, 0.6, 0.9, 0.75],
                expensePoints: [0.1, 0.25, 0.2, 0.3, 0.4, 0.2, 0.35],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Mon', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Tue', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Wed', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Thu', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Fri', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Sat', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Sun', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _subTab(String text, int index) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final bool isDark;
  final List<double> incomePoints;
  final List<double> expensePoints;

  LineChartPainter({
    required this.isDark,
    required this.incomePoints,
    required this.expensePoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final incomePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final expensePaint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pathIncome = Path();
    final pathExpense = Path();

    double dx = size.width / (incomePoints.length - 1);

    for (int i = 0; i < incomePoints.length; i++) {
      double x = i * dx;
      double yIncome = size.height - (incomePoints[i] * size.height);
      double yExpense = size.height - (expensePoints[i] * size.height);

      if (i == 0) {
        pathIncome.moveTo(x, yIncome);
        pathExpense.moveTo(x, yExpense);
      } else {
        pathIncome.lineTo(x, yIncome);
        pathExpense.lineTo(x, yExpense);
      }
    }

    canvas.drawPath(pathIncome, incomePaint);
    canvas.drawPath(pathExpense, expensePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}