import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double emptyWidth;
  final double height;

  const DashedDivider({
    super.key,
    this.color = Colors.grey,
    this.dashWidth = 5.0,
    this.emptyWidth = 3.0,
    this.height = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + emptyWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
