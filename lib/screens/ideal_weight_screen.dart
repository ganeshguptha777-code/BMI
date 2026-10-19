import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../widgets/custom_card.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/disclaimer_card.dart';

class IdealWeightScreen extends StatefulWidget {
  const IdealWeightScreen({super.key});

  @override
  State<IdealWeightScreen> createState() => _IdealWeightScreenState();
}

class _IdealWeightScreenState extends State<IdealWeightScreen> {
  String _gender = 'Male';
  int _heightUnitIndex = 0; // 0 = cm, 1 = ft/in

  final TextEditingController _heightCmController = TextEditingController(text: '175');
  final TextEditingController _heightFtController = TextEditingController(text: '5');
  final TextEditingController _heightInController = TextEditingController(text: '9');
  final TextEditingController _currentWeightController = TextEditingController(text: '72');

  IdealWeightResult? _result;

  @override
  void initState() {
    super.initState();
    _computeIdealWeight();
  }

  @override
  void dispose() {
    _heightCmController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    _currentWeightController.dispose();
    super.dispose();
  }

  void _computeIdealWeight() {
    double heightCm = 175;
    if (_heightUnitIndex == 0) {
      heightCm = double.tryParse(_heightCmController.text) ?? 175;
    } else {
      final ft = double.tryParse(_heightFtController.text) ?? 5;
      final inch = double.tryParse(_heightInController.text) ?? 9;
      heightCm = ((ft * 12) + inch) * 2.54;
    }

    final curWeight = double.tryParse(_currentWeightController.text);

    final res = IdealWeightResult.calculate(
      heightCm: heightCm,
      gender: _gender,
      currentWeightKg: curWeight,
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
        title: const Text('Ideal Body Weight'),
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
                'Optimal Weight Spectrum',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Estimates your ideal biological weight target using the Devine, Robinson, and WHO methods.',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Inputs Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender
                    Text('Gender', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Male', 'Female'].map((g) {
                        final isSel = _gender == g;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _gender = g);
                              _computeIdealWeight();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? const Color(0xFF8B5CF6).withOpacity(0.12)
                                    : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel ? const Color(0xFF8B5CF6) : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    g == 'Male' ? Icons.male_rounded : Icons.female_rounded,
                                    size: 18,
                                    color: isSel ? const Color(0xFF8B5CF6) : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    g,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                      color: isSel ? const Color(0xFF8B5CF6) : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // Height with Unit Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Height', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                        UnitToggle(
                          options: const ['cm', 'ft / in'],
                          selectedIndex: _heightUnitIndex,
                          onSelected: (idx) {
                            setState(() => _heightUnitIndex = idx);
                            _computeIdealWeight();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_heightUnitIndex == 0)
                      TextFormField(
                        controller: _heightCmController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => _computeIdealWeight(),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.height_rounded, size: 22),
                          suffixText: 'cm',
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _heightFtController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (_) => _computeIdealWeight(),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.height_rounded, size: 22),
                                suffixText: 'ft',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _heightInController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (_) => _computeIdealWeight(),
                              decoration: const InputDecoration(
                                suffixText: 'in',
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 18),

                    // Current Weight (Optional)
                    Text('Current Weight (Optional Comparison)', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _currentWeightController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (_) => _computeIdealWeight(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.monitor_weight_outlined, size: 22),
                        suffixText: 'kg',
                      ),
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
                    colors: [Color(0xFF6D28D9), Color(0xFF7C3AED), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Estimated Ideal Weight',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_result!.devineWeightKg} kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'Clinical standard (Devine Formula)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _result!.summary,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Formulas Comparison Matrix
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clinical Formulas Comparison',
                        style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      _buildFormulaRow('WHO Healthy BMI Range (18.5 – 24.9)', '${_result!.whoMinKg} – ${_result!.whoMaxKg} kg', theme),
                      const Divider(height: 18),
                      _buildFormulaRow('Devine Equation (1974)', '${_result!.devineWeightKg} kg', theme),
                      const Divider(height: 18),
                      _buildFormulaRow('Robinson Equation (1983)', '${_result!.robinsonWeightKg} kg', theme),
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

  Widget _buildFormulaRow(String name, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }
}
