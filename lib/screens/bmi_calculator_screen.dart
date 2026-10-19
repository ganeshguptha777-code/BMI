import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../widgets/custom_card.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/disclaimer_card.dart';
import 'bmi_result_screen.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = 'Male';
  int _heightUnitIndex = 0; // 0 = cm, 1 = ft/in
  int _weightUnitIndex = 0; // 0 = kg, 1 = lb

  final TextEditingController _ageController = TextEditingController(text: '25');
  final TextEditingController _heightCmController = TextEditingController(text: '175');
  final TextEditingController _heightFeetController = TextEditingController(text: '5');
  final TextEditingController _heightInchesController = TextEditingController(text: '9');
  final TextEditingController _weightController = TextEditingController(text: '70');

  String? _errorMessage;

  @override
  void dispose() {
    _ageController.dispose();
    _heightCmController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    setState(() {
      _errorMessage = null;
    });

    final age = int.tryParse(_ageController.text.trim());
    if (age == null || age < 5 || age > 120) {
      setState(() {
        _errorMessage = 'Please enter a valid age between 5 and 120 years.';
      });
      return;
    }

    double? heightInCm;
    if (_heightUnitIndex == 0) {
      heightInCm = double.tryParse(_heightCmController.text.trim());
    } else {
      final feet = double.tryParse(_heightFeetController.text.trim()) ?? 0;
      final inches = double.tryParse(_heightInchesController.text.trim()) ?? 0;
      final totalInches = (feet * 12) + inches;
      if (totalInches > 0) {
        heightInCm = totalInches * 2.54;
      }
    }

    if (heightInCm == null || heightInCm < 50 || heightInCm > 260) {
      setState(() {
        _errorMessage = 'Please enter a realistic height between 50 cm and 260 cm (approx 1\'8" to 8\'6").';
      });
      return;
    }

    double? rawWeight = double.tryParse(_weightController.text.trim());
    if (rawWeight == null || rawWeight <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid weight value.';
      });
      return;
    }

    double weightInKg;
    if (_weightUnitIndex == 0) {
      weightInKg = rawWeight;
    } else {
      // 1 lb = 0.453592 kg
      weightInKg = rawWeight * 0.45359237;
    }

    if (weightInKg < 20 || weightInKg > 350) {
      setState(() {
        _errorMessage = 'Please enter a realistic weight between 20 kg and 350 kg (44 lb - 770 lb).';
      });
      return;
    }

    // BMI Formula: BMI = weight in kilograms / (height in meters * height in meters)
    final result = BMIResult.calculate(
      heightCm: heightInCm,
      weightKg: weightInKg,
      age: age,
      gender: _selectedGender,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BMIResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Info
                Text(
                  'Body Mass Index',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your physical metrics below to calculate your BMI and healthy target weight.',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),

                const SizedBox(height: 20),

                // Error Message Banner (if any)
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFF991B1B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 1. Gender Selection
                Text(
                  'Select Gender',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderCard(
                        gender: 'Male',
                        icon: Icons.male_rounded,
                        accentColor: const Color(0xFF2563EB),
                        isSelected: _selectedGender == 'Male',
                        onTap: () => setState(() => _selectedGender = 'Male'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderCard(
                        gender: 'Female',
                        icon: Icons.female_rounded,
                        accentColor: const Color(0xFFEC4899),
                        isSelected: _selectedGender == 'Female',
                        onTap: () => setState(() => _selectedGender = 'Female'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. Age Input
                Text(
                  'Age (Years)',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g. 25',
                    prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                    suffixText: 'years',
                    suffixStyle: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Height Input with cm / ft toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Height',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    UnitToggle(
                      options: const ['cm', 'ft / in'],
                      selectedIndex: _heightUnitIndex,
                      onSelected: (index) {
                        setState(() {
                          _heightUnitIndex = index;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (_heightUnitIndex == 0)
                  TextFormField(
                    controller: _heightCmController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. 175',
                      prefixIcon: const Icon(Icons.height_rounded, size: 22),
                      suffixText: 'cm',
                      suffixStyle: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heightFeetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Feet',
                            prefixIcon: const Icon(Icons.height_rounded, size: 22),
                            suffixText: 'ft',
                            suffixStyle: TextStyle(
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _heightInchesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Inches',
                            suffixText: 'in',
                            suffixStyle: TextStyle(
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // 4. Weight Input with kg / lb toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weight',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    UnitToggle(
                      options: const ['kg', 'lb'],
                      selectedIndex: _weightUnitIndex,
                      onSelected: (index) {
                        setState(() {
                          _weightUnitIndex = index;
                          // Optional conversion convenience
                          final val = double.tryParse(_weightController.text);
                          if (val != null) {
                            if (index == 1) {
                              // kg to lb
                              _weightController.text = (val * 2.20462).toStringAsFixed(1);
                            } else {
                              // lb to kg
                              _weightController.text = (val / 2.20462).toStringAsFixed(1);
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: _weightUnitIndex == 0 ? 'e.g. 70' : 'e.g. 154',
                    prefixIcon: const Icon(Icons.monitor_weight_outlined, size: 22),
                    suffixText: _weightUnitIndex == 0 ? 'kg' : 'lb',
                    suffixStyle: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Disclaimer
                const DisclaimerCard(),

                const SizedBox(height: 24),

                // Calculate BMI Button
                ElevatedButton.icon(
                  onPressed: _calculateBMI,
                  icon: const Icon(Icons.calculate_rounded),
                  label: const Text('Calculate BMI'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String gender,
    required IconData icon,
    required Color accentColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      onTap: onTap,
      border: Border.all(
        color: isSelected ? accentColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        width: isSelected ? 2 : 1,
      ),
      color: isSelected
          ? accentColor.withOpacity(isDark ? 0.2 : 0.08)
          : null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            gender,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? accentColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
