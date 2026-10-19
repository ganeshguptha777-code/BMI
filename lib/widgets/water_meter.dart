import 'package:flutter/material.dart';

class WaterMeter extends StatelessWidget {
  final int currentMl;
  final int goalMl;
  final double size;

  const WaterMeter({
    super.key,
    required this.currentMl,
    required this.goalMl,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = goalMl > 0 ? (currentMl / goalMl).clamp(0.0, 1.0) : 0.0;
    final int percentage = (ratio * 100).round();

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Indicator Ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: ratio,
              strokeWidth: 12,
              strokeCap: StrokeCap.round,
              backgroundColor: const Color(0xFFE0F2FE),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
            ),
          ),

          // Central Icon and Metrics
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Color(0xFF0284C7),
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '$currentMl / $goalMl ml',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
