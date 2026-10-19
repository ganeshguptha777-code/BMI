import 'package:flutter/material.dart';
import '../models/health_models.dart';

class BMIScaleBar extends StatelessWidget {
  final double? currentBmi;
  final bool showLabels;

  const BMIScaleBar({
    super.key,
    this.currentBmi,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Minimum display scale is 14.0, maximum is 38.0 (range of 24)
    const double minScale = 14.0;
    const double maxScale = 38.0;

    double normalizedRatio = 0.5;
    if (currentBmi != null) {
      final clamped = currentBmi!.clamp(minScale, maxScale);
      normalizedRatio = (clamped - minScale) / (maxScale - minScale);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Marker Pointer
        if (currentBmi != null)
          LayoutBuilder(
            builder: (context, constraints) {
              final double trackWidth = constraints.maxWidth;
              final double pointerX = (trackWidth * normalizedRatio).clamp(16.0, trackWidth - 16.0);

              return Stack(
                children: [
                  SizedBox(
                    height: 28,
                    width: trackWidth,
                  ),
                  Positioned(
                    left: pointerX - 22,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getBmiColor(currentBmi!),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: _getBmiColor(currentBmi!).withOpacity(0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        currentBmi!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

        const SizedBox(height: 2),

        // Gradient & Segmented Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                // Underweight (< 18.5) -> (18.5 - 14) / 24 = 4.5 / 24 = 18.75%
                Expanded(
                  flex: 45,
                  child: Container(
                    color: BMICategory.underweight.color,
                  ),
                ),
                const SizedBox(width: 2),
                // Normal (18.5 - 24.9) -> 6.4 / 24 = ~26.7%
                Expanded(
                  flex: 64,
                  child: Container(
                    color: BMICategory.normal.color,
                  ),
                ),
                const SizedBox(width: 2),
                // Overweight (25.0 - 29.9) -> 5.0 / 24 = ~20.8%
                Expanded(
                  flex: 50,
                  child: Container(
                    color: BMICategory.overweight.color,
                  ),
                ),
                const SizedBox(width: 2),
                // Obese (>= 30.0) -> 8.1 / 24 = ~33.7%
                Expanded(
                  flex: 81,
                  child: Container(
                    color: BMICategory.obesity.color,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Scale Labels
        if (showLabels)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSegmentLabel('< 18.5', 'Underweight', BMICategory.underweight.color, isDark),
              _buildSegmentLabel('18.5–24.9', 'Normal', BMICategory.normal.color, isDark),
              _buildSegmentLabel('25–29.9', 'Overweight', BMICategory.overweight.color, isDark),
              _buildSegmentLabel('≥ 30.0', 'Obese', BMICategory.obesity.color, isDark),
            ],
          ),
      ],
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return BMICategory.underweight.color;
    if (bmi < 25.0) return BMICategory.normal.color;
    if (bmi < 30.0) return BMICategory.overweight.color;
    return BMICategory.obesity.color;
  }

  Widget _buildSegmentLabel(String range, String title, Color color, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              range,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
