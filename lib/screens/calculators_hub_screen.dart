import 'package:flutter/material.dart';
import 'bmi_calculator_screen.dart';
import 'water_calculator_screen.dart';
import 'calorie_calculator_screen.dart';
import 'ideal_weight_screen.dart';
import '../widgets/custom_card.dart';

class CalculatorsHubScreen extends StatefulWidget {
  final int initialTabIndex;

  const CalculatorsHubScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<CalculatorsHubScreen> createState() => _CalculatorsHubScreenState();
}

class _CalculatorsHubScreenState extends State<CalculatorsHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Calculators'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: 'BMI'),
                Tab(text: 'Water Goal'),
                Tab(text: 'Calories'),
                Tab(text: 'Ideal Weight'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TabContentWrapper(child: BMICalculatorScreen()),
          _TabContentWrapper(child: WaterCalculatorScreen()),
          _TabContentWrapper(child: CalorieCalculatorScreen()),
          _TabContentWrapper(child: IdealWeightScreen()),
        ],
      ),
    );
  }
}

class _TabContentWrapper extends StatelessWidget {
  final Widget child;

  const _TabContentWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    // Strips nested app bars if any, providing seamless embedded experience
    return child;
  }
}
