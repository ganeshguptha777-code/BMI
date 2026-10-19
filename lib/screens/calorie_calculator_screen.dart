import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../widgets/custom_card.dart';
import '../widgets/disclaimer_card.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({super.key});

  @override
  State<CalorieCalculatorScreen> createState() => _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  String _gender = 'Male';
  final TextEditingController _ageController = TextEditingController(text: '28');
  final TextEditingController _heightController = TextEditingController(text: '175');
  final TextEditingController _weightController = TextEditingController(text: '72');

  ActivityLevel _activityLevel = ActivityLevel.moderate;
  CalorieGoal _goal = CalorieGoal.maintain;

  CalorieResult? _result;

  @override
  void initState() {
    super.initState();
    _computeCalories();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _computeCalories() {
    final age = int.tryParse(_ageController.text) ?? 28;
    final height = double.tryParse(_heightController.text) ?? 175;
    final weight = double.tryParse(_weightController.text) ?? 72;

    final res = CalorieResult.calculate(
      weightKg: weight,
      heightCm: height,
      age: age,
      gender: _gender,
      activityLevel: _activityLevel,
      goal: _goal,
    );

    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Calorie Needs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Energy & Metabolism',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Calculates your Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE).',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Inputs Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender selector
                    Text('Gender', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Male', 'Female'].map((g) {
                        final isSel = _gender == g;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _gender = g);
                              _computeCalories();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? const Color(0xFF10B981).withOpacity(0.12)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF10B981) : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    g == 'Male' ? Icons.male_rounded : Icons.female_rounded,
                                    size: 18,
                                    color: isSel ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    g,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                      color: isSel ? const Color(0xFF10B981) : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Age, Height, Weight Fields
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age', style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _ageController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (_) => _computeCalories(),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                  suffixText: 'yr',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Height', style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (_) => _computeCalories(),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                  suffixText: 'cm',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weight', style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                onChanged: (_) => _computeCalories(),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                  suffixText: 'kg',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Activity Level
                    Text('Activity Level', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ActivityLevel>(
                          value: _activityLevel,
                          isExpanded: true,
                          items: ActivityLevel.values.map((lvl) {
                            return DropdownMenuItem(
                              value: lvl,
                              child: Text(
                                '${lvl.title} (${lvl.subtitle})',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _activityLevel = val);
                              _computeCalories();
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Primary Goal
                    Text('Primary Fitness Goal', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: CalorieGoal.values.map((g) {
                        final isSel = _goal == g;
                        return ChoiceChip(
                          label: Text(g.label),
                          selected: isSel,
                          onSelected: (sel) {
                            if (sel) {
                              setState(() => _goal = g);
                              _computeCalories();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Results Card
              if (_result != null) ...[
                CustomCard(
                  padding: const EdgeInsets.all(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Target Daily Energy',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_result!.targetCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'Daily calories to ${_goal.label.toLowerCase()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // BMR & TDEE stats row
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Basal (BMR)', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text(
                                  '${_result!.bmr.toStringAsFixed(0)} kcal',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 28, color: Colors.white24),
                            Column(
                              children: [
                                const Text('Maintenance (TDEE)', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text(
                                  '${_result!.tdee.toStringAsFixed(0)} kcal',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Balanced Macronutrients Breakdown
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggested Balanced Macronutrient Split',
                        style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildMacroPill(
                            title: 'Protein (30%)',
                            grams: '${_result!.proteinGrams}g',
                            color: const Color(0xFFEF4444),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 10),
                          _buildMacroPill(
                            title: 'Carbs (40%)',
                            grams: '${_result!.carbsGrams}g',
                            color: const Color(0xFF10B981),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 10),
                          _buildMacroPill(
                            title: 'Fats (30%)',
                            grams: '${_result!.fatGrams}g',
                            color: const Color(0xFFF59E0B),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const DisclaimerCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroPill({
    required String title,
    required String grams,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              grams,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
