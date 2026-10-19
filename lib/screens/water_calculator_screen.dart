import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../widgets/custom_card.dart';
import '../widgets/water_meter.dart';
import '../widgets/disclaimer_card.dart';

class WaterCalculatorScreen extends StatefulWidget {
  const WaterCalculatorScreen({super.key});

  @override
  State<WaterCalculatorScreen> createState() => _WaterCalculatorScreenState();
}

class _WaterCalculatorScreenState extends State<WaterCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController(text: '70');
  String _activityIntensity = 'Moderate'; // Low, Moderate, High
  bool _isHotClimate = false;

  int _recommendedMl = 2700;
  int _loggedMl = 1250;

  @override
  void initState() {
    super.initState();
    _recalculateGoal();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _recalculateGoal() {
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final res = WaterIntakeResult.calculate(
      weightKg: weight,
      activityIntensity: _activityIntensity,
      isHotClimate: _isHotClimate,
    );
    setState(() {
      _recommendedMl = res.recommendedMl;
      if (_loggedMl > _recommendedMl + 1000) {
        _loggedMl = _recommendedMl;
      }
    });
  }

  void _addGlass() {
    setState(() {
      _loggedMl = (_loggedMl + 250).clamp(0, 8000);
    });
  }

  void _removeGlass() {
    setState(() {
      _loggedMl = (_loggedMl - 250).clamp(0, 8000);
    });
  }

  void _resetWater() {
    setState(() {
      _loggedMl = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final int glassesLogged = (_loggedMl / 250).floor();
    final int targetGlasses = (_recommendedMl / 250).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Water Intake'),
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
              // Header
              Text(
                'Hydration Tracker & Goal',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Proper hydration fuels cellular health, sustained cognitive energy, and digestion.',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Visual Water Meter Card
              CustomCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    WaterMeter(
                      currentMl: _loggedMl,
                      goalMl: _recommendedMl,
                      size: 190,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$glassesLogged of $targetGlasses glasses (250 ml each)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick Log Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _loggedMl > 0 ? _removeGlass : null,
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _addGlass,
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text('+ 1 Glass (250ml)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Reset Tracker',
                          icon: const Icon(Icons.restart_alt_rounded, color: Color(0xFF94A3B8)),
                          onPressed: _resetWater,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Personalized Parameters Section
              Text(
                'Personalize Your Water Target',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 10),

              CustomCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weight
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Your Weight (kg)',
                            style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (_) => _recalculateGoal(),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              suffixText: 'kg',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),

                    // Activity Level
                    Text(
                      'Daily Activity Intensity',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Low', 'Moderate', 'High'].map((intensity) {
                        final isSel = _activityIntensity == intensity;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activityIntensity = intensity;
                              });
                              _recalculateGoal();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? const Color(0xFF0284C7).withOpacity(0.12)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF0284C7) : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                intensity,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? const Color(0xFF0284C7) : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 28),

                    // Hot Climate Toggle
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hot or Humid Environment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Adds 500 ml for perspiration losses', style: TextStyle(fontSize: 11)),
                      value: _isHotClimate,
                      onChanged: (val) {
                        setState(() {
                          _isHotClimate = val;
                        });
                        _recalculateGoal();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Hydration Health Tip Card
              CustomCard(
                padding: const EdgeInsets.all(18),
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F9FF),
                border: Border.all(
                  color: const Color(0xFF0284C7).withOpacity(0.3),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, color: Color(0xFF0284C7), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hydration Best Practice',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sip water steadily across your waking hours rather than chugging large amounts in one go. Pale straw-colored urine is the gold standard indicator of optimal hydration.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const DisclaimerCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
