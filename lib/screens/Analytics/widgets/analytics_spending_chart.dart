import 'package:flutter/material.dart';
import '../models/analytics_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsSpendingChart extends StatefulWidget {
  final List<ChartDataPoint> points;

  const AnalyticsSpendingChart({
    Key? key,
    required this.points,
  }) : super(key: key);

  @override
  State<AnalyticsSpendingChart> createState() => _AnalyticsSpendingChartState();
}

class _AnalyticsSpendingChartState extends State<AnalyticsSpendingChart> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.points.isNotEmpty) {
      _selectedIndex = widget.points.length - 1; // Default select latest point
    }
  }

  @override
  void didUpdateWidget(covariant AnalyticsSpendingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.points.isNotEmpty) {
      _selectedIndex = widget.points.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final gridLineColor = isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder;

    final activePoint = (_selectedIndex != null && _selectedIndex! < widget.points.length)
        ? widget.points[_selectedIndex!]
        : widget.points.last;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spending Overview',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              // Floating legend tooltip directly integrated into chart header
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activePoint.label,
                      style: TextStyle(color: subTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    _LegendRow(label: 'Deposits', value: '\$${activePoint.deposits.toStringAsFixed(0)}', color: AppColors.primary),
                    _LegendRow(label: 'Withdrawals', value: '\$${activePoint.withdrawals.toStringAsFixed(0)}', color: AppColors.accentViolet),
                    _LegendRow(label: 'Buy Cards', value: '\$${activePoint.buyCards.toStringAsFixed(0)}', color: AppColors.secondary),
                    _LegendRow(label: 'Sell Cards', value: '\$${activePoint.sellCards.toStringAsFixed(0)}', color: AppColors.accent),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                // Y-Axis Labels
                SizedBox(
                  width: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$6k', style: TextStyle(color: subTextColor, fontSize: 10)),
                      Text('\$4k', style: TextStyle(color: subTextColor, fontSize: 10)),
                      Text('\$2k', style: TextStyle(color: subTextColor, fontSize: 10)),
                      Text('\$0', style: TextStyle(color: subTextColor, fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Custom Multi-Line Chart Canvas
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) => _handleTouch(details.localPosition),
                    onTapDown: (details) => _handleTouch(details.localPosition),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _MultiLineChartPainter(
                        points: widget.points,
                        selectedIndex: _selectedIndex,
                        gridColor: gridLineColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // X-Axis Labels
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.points.map((p) {
                final isSelected = widget.points.indexOf(p) == _selectedIndex;
                return Text(
                  p.label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : subTextColor,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTouch(Offset localPosition) {
    if (widget.points.isEmpty) return;
    final chartWidth = context.size?.width ?? 300 - 40;
    final stepWidth = chartWidth / (widget.points.length - 1);
    int index = (localPosition.dx / stepWidth).round();
    if (index < 0) index = 0;
    if (index >= widget.points.length) index = widget.points.length - 1;
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LegendRow({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontSize: 9)),
          const SizedBox(width: 8),
          Text(value, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MultiLineChartPainter extends CustomPainter {
  final List<ChartDataPoint> points;
  final int? selectedIndex;
  final Color gridColor;

  _MultiLineChartPainter({
    required this.points,
    required this.selectedIndex,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    // Draw 4 Horizontal Gridlines
    for (int i = 0; i < 4; i++) {
      double y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const maxVal = 6000.0;
    final stepX = size.width / (points.length - 1);

    // Render Data Series Lines
    _drawLine(canvas, size, points.map((p) => p.deposits).toList(), maxVal, stepX, AppColors.primary);
    _drawLine(canvas, size, points.map((p) => p.withdrawals).toList(), maxVal, stepX, AppColors.accentViolet);
    _drawLine(canvas, size, points.map((p) => p.buyCards).toList(), maxVal, stepX, AppColors.secondary);
    _drawLine(canvas, size, points.map((p) => p.sellCards).toList(), maxVal, stepX, AppColors.accent);

    // Selected Touch Vertical Indicator
    if (selectedIndex != null && selectedIndex! < points.length) {
      final selectedX = selectedIndex! * stepX;
      final touchPaint = Paint()
        ..color = AppColors.primary.withOpacity(0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(selectedX, 0), Offset(selectedX, size.height), touchPaint);

      // Draw active highlight dots
      _drawDot(canvas, selectedX, size.height - (points[selectedIndex!].deposits / maxVal) * size.height, AppColors.primary);
      _drawDot(canvas, selectedX, size.height - (points[selectedIndex!].withdrawals / maxVal) * size.height, AppColors.accentViolet);
      _drawDot(canvas, selectedX, size.height - (points[selectedIndex!].buyCards / maxVal) * size.height, AppColors.secondary);
      _drawDot(canvas, selectedX, size.height - (points[selectedIndex!].sellCards / maxVal) * size.height, AppColors.accent);
    }
  }

  void _drawLine(Canvas canvas, Size size, List<double> values, double maxVal, double stepX, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      double x = i * stepX;
      double y = size.height - (values[i] / maxVal) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        double prevX = (i - 1) * stepX;
        double prevY = size.height - (values[i - 1] / maxVal) * size.height;
        path.cubicTo((prevX + x) / 2, prevY, (prevX + x) / 2, y, x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawDot(Canvas canvas, double x, double y, Color color) {
    canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MultiLineChartPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex || oldDelegate.points != points;
}