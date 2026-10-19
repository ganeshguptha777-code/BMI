import 'package:flutter/material.dart';

enum BMICategory {
  underweight,
  normal,
  overweight,
  obesity;

  String get label {
    switch (this) {
      case BMICategory.underweight:
        return 'Underweight';
      case BMICategory.normal:
        return 'Normal Weight';
      case BMICategory.overweight:
        return 'Overweight';
      case BMICategory.obesity:
        return 'Obese';
    }
  }

  Color get color {
    switch (this) {
      case BMICategory.underweight:
        return const Color(0xFF0284C7); // Sky Blue
      case BMICategory.normal:
        return const Color(0xFF10B981); // Emerald Green
      case BMICategory.overweight:
        return const Color(0xFFF59E0B); // Amber
      case BMICategory.obesity:
        return const Color(0xFFEF4444); // Red
    }
  }

  String get rangeDescription {
    switch (this) {
      case BMICategory.underweight:
        return '< 18.5 kg/m²';
      case BMICategory.normal:
        return '18.5 – 24.9 kg/m²';
      case BMICategory.overweight:
        return '25.0 – 29.9 kg/m²';
      case BMICategory.obesity:
        return '≥ 30.0 kg/m²';
    }
  }

  String get shortExplanation {
    switch (this) {
      case BMICategory.underweight:
        return 'Your BMI indicates you may be below the standard healthy weight threshold. Focusing on nutrient-dense meals and strength training can support healthy weight gain.';
      case BMICategory.normal:
        return 'Fantastic! Your BMI is within the healthy reference range. Maintaining your balanced lifestyle, hydration, and regular exercise will keep you feeling your best.';
      case BMICategory.overweight:
        return 'Your BMI is slightly above the standard range. Gentle daily lifestyle adjustments, mindful portion sizes, and brisk walks can help guide you toward optimal wellness.';
      case BMICategory.obesity:
        return 'Your BMI falls into the higher range. Consider consulting a registered dietitian or healthcare provider for a sustainable, personalized wellness plan.';
    }
  }

  List<String> get keyTips {
    switch (this) {
      case BMICategory.underweight:
        return [
          'Incorporate wholesome snacks like nuts, seeds, and avocados.',
          'Focus on progressive resistance and strength training.',
          'Ensure regular protein intake throughout the day.',
        ];
      case BMICategory.normal:
        return [
          'Aim for at least 150 minutes of moderate aerobic activity weekly.',
          'Keep hydration consistent with 2 to 3 liters of water daily.',
          'Prioritize 7–9 hours of restorative sleep every night.',
        ];
      case BMICategory.overweight:
        return [
          'Increase fiber-rich vegetables, legumes, and whole grains.',
          'Replace sugary beverages with water or herbal teas.',
          'Add a 30-minute brisk walk into your daily routine.',
        ];
      case BMICategory.obesity:
        return [
          'Focus on gradual, sustainable habits rather than extreme diets.',
          'Track your daily movement and celebrate consistent progress.',
          'Work with healthcare professionals for holistic guidance.',
        ];
    }
  }
}

class BMIResult {
  final double bmiValue;
  final BMICategory category;
  final double heightCm;
  final double weightKg;
  final double healthyWeightMin;
  final double healthyWeightMax;
  final int age;
  final String gender;

  const BMIResult({
    required this.bmiValue,
    required this.category,
    required this.heightCm,
    required this.weightKg,
    required this.healthyWeightMin,
    required this.healthyWeightMax,
    required this.age,
    required this.gender,
  });

  static BMIResult calculate({
    required double heightCm,
    required double weightKg,
    required int age,
    required String gender,
  }) {
    final heightMeters = heightCm / 100.0;
    final bmi = weightKg / (heightMeters * heightMeters);

    BMICategory category;
    if (bmi < 18.5) {
      category = BMICategory.underweight;
    } else if (bmi < 25.0) {
      category = BMICategory.normal;
    } else if (bmi < 30.0) {
      category = BMICategory.overweight;
    } else {
      category = BMICategory.obesity;
    }

    final healthyMin = 18.5 * (heightMeters * heightMeters);
    final healthyMax = 24.9 * (heightMeters * heightMeters);

    return BMIResult(
      bmiValue: double.parse(bmi.toStringAsFixed(1)),
      category: category,
      heightCm: heightCm,
      weightKg: weightKg,
      healthyWeightMin: double.parse(healthyMin.toStringAsFixed(1)),
      healthyWeightMax: double.parse(healthyMax.toStringAsFixed(1)),
      age: age,
      gender: gender,
    );
  }
}

enum ActivityLevel {
  sedentary('Sedentary', 'Little or no exercise, desk job', 1.2),
  light('Lightly Active', 'Light workouts 1–3 days/week', 1.375),
  moderate('Moderately Active', 'Moderate exercise 3–5 days/week', 1.55),
  active('Very Active', 'Hard training 6–7 days/week', 1.725),
  extra('Extra Active', 'Athletic training or physical labor', 1.9);

  final String title;
  final String subtitle;
  final double multiplier;

  const ActivityLevel(this.title, this.subtitle, this.multiplier);
}

enum CalorieGoal {
  mildLoss('Mild Weight Loss', -300),
  maintain('Maintain Weight', 0),
  moderateLoss('Moderate Loss', -500),
  muscleGain('Muscle Gain', 300);

  final String label;
  final int offsetKcal;

  const CalorieGoal(this.label, this.offsetKcal);
}

class CalorieResult {
  final double bmr;
  final double tdee;
  final double targetCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;

  const CalorieResult({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  static CalorieResult calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required ActivityLevel activityLevel,
    required CalorieGoal goal,
  }) {
    // Mifflin-St Jeor Formula
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    final tdee = bmr * activityLevel.multiplier;
    final target = (tdee + goal.offsetKcal).clamp(1200.0, 4500.0);

    // Approximate balanced macros (30% Protein, 40% Carbs, 30% Fat)
    final protein = (target * 0.30 / 4).round();
    final carbs = (target * 0.40 / 4).round();
    final fat = (target * 0.30 / 9).round();

    return CalorieResult(
      bmr: double.parse(bmr.toStringAsFixed(0)),
      tdee: double.parse(tdee.toStringAsFixed(0)),
      targetCalories: double.parse(target.toStringAsFixed(0)),
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
    );
  }
}

class WaterIntakeResult {
  final int recommendedMl;
  final int glasses;
  final String tip;

  const WaterIntakeResult({
    required this.recommendedMl,
    required this.glasses,
    required this.tip,
  });

  static WaterIntakeResult calculate({
    required double weightKg,
    required String activityIntensity,
    required bool isHotClimate,
  }) {
    // Baseline: ~33ml per kg
    double ml = weightKg * 33.0;

    if (activityIntensity == 'Moderate') {
      ml += 400;
    } else if (activityIntensity == 'High') {
      ml += 800;
    }

    if (isHotClimate) {
      ml += 500;
    }

    final totalMl = ml.round().clamp(1500, 5000);
    final glasses = (totalMl / 250).ceil();

    String tip = 'Keep a reusable bottle nearby to steadily hydrate throughout your day.';
    if (totalMl > 3000) {
      tip = 'Higher activity levels demand electrolyte balance alongside pure water.';
    }

    return WaterIntakeResult(
      recommendedMl: totalMl,
      glasses: glasses,
      tip: tip,
    );
  }
}

class IdealWeightResult {
  final double devineWeightKg;
  final double robinsonWeightKg;
  final double whoMinKg;
  final double whoMaxKg;
  final String summary;

  const IdealWeightResult({
    required this.devineWeightKg,
    required this.robinsonWeightKg,
    required this.whoMinKg,
    required this.whoMaxKg,
    required this.summary,
  });

  static IdealWeightResult calculate({
    required double heightCm,
    required String gender,
    double? currentWeightKg,
  }) {
    // Height in inches over 5 feet (60 inches)
    final totalInches = heightCm / 2.54;
    final inchesOver60 = (totalInches - 60).clamp(0.0, 40.0);

    double devine;
    double robinson;

    if (gender.toLowerCase() == 'male') {
      devine = 50.0 + (2.3 * inchesOver60);
      robinson = 52.0 + (1.9 * inchesOver60);
    } else {
      devine = 45.5 + (2.3 * inchesOver60);
      robinson = 49.0 + (1.7 * inchesOver60);
    }

    final heightMeters = heightCm / 100.0;
    final whoMin = 18.5 * (heightMeters * heightMeters);
    final whoMax = 24.9 * (heightMeters * heightMeters);

    String summaryText = 'Healthy weight ranges support long-term metabolic health and energy.';
    if (currentWeightKg != null && currentWeightKg > 0) {
      if (currentWeightKg < whoMin) {
        summaryText = 'You are currently ${(whoMin - currentWeightKg).toStringAsFixed(1)} kg below the standard normal range.';
      } else if (currentWeightKg > whoMax) {
        summaryText = 'You are currently ${(currentWeightKg - whoMax).toStringAsFixed(1)} kg above the standard normal range.';
      } else {
        summaryText = 'Great job! Your current weight is inside the optimal healthy spectrum.';
      }
    }

    return IdealWeightResult(
      devineWeightKg: double.parse(devine.toStringAsFixed(1)),
      robinsonWeightKg: double.parse(robinson.toStringAsFixed(1)),
      whoMinKg: double.parse(whoMin.toStringAsFixed(1)),
      whoMaxKg: double.parse(whoMax.toStringAsFixed(1)),
      summary: summaryText,
    );
  }
}

class HealthTip {
  final String id;
  final String title;
  final String category;
  final String description;
  final String fullAdvice;
  final String readTime;
  final IconData icon;
  final Color accentColor;

  const HealthTip({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.fullAdvice,
    required this.readTime,
    required this.icon,
    required this.accentColor,
  });

  static const List<HealthTip> sampleTips = [
    HealthTip(
      id: '1',
      title: 'Morning Hydration Kickstart',
      category: 'Hydration',
      description: 'Drink 500 ml of lukewarm water right after waking up to activate your metabolism.',
      fullAdvice: 'During sleep, your body naturally loses moisture through breathing and perspiration. Drinking room-temperature or lukewarm water right after waking reactivates your digestion, enhances alertness, and helps flush out overnight cellular waste.',
      readTime: '2 min read',
      icon: Icons.water_drop_rounded,
      accentColor: Color(0xFF0284C7),
    ),
    HealthTip(
      id: '2',
      title: 'The Balanced Plate Rule',
      category: 'Nutrition',
      description: 'Fill half your plate with colorful vegetables, one quarter with lean protein, and one quarter with complex carbs.',
      fullAdvice: 'The plate method is an intuitive, sustainable way to manage portions without counting grams. Greens and vibrant vegetables deliver micronutrients and fiber, proteins support satiety and muscle repair, while complex carbs provide steady energy without blood sugar spikes.',
      readTime: '3 min read',
      icon: Icons.restaurant_rounded,
      accentColor: Color(0xFF10B981),
    ),
    HealthTip(
      id: '3',
      title: '10-Minute Post-Meal Walks',
      category: 'Exercise',
      description: 'A gentle 10-minute stroll after lunch or dinner significantly flattens post-meal blood sugar surges.',
      fullAdvice: 'Muscles absorb circulating glucose directly through non-insulin-mediated pathways during light movement. A brief 10 to 15 minute stroll after meals promotes smooth digestion and mitigates energy crashes without requiring intense exertion.',
      readTime: '2 min read',
      icon: Icons.directions_walk_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    HealthTip(
      id: '4',
      title: 'The 60-Minute Digital Sunset',
      category: 'Sleep',
      description: 'Switch off phone, tablet, and laptop screens 60 minutes prior to bedtime.',
      fullAdvice: 'Blue light emitted by digital displays suppresses pineal melatonin production, delaying your sleep onset and diminishing restorative deep sleep cycles. Replace screen scrolling with reading paper books, journaling, or breathwork for deeper rest.',
      readTime: '3 min read',
      icon: Icons.bedtime_rounded,
      accentColor: Color(0xFF6366F1),
    ),
    HealthTip(
      id: '5',
      title: 'Box Breathing for Instant Calm',
      category: 'Mental Wellness',
      description: 'Inhale for 4 seconds, hold for 4, exhale for 4, and hold for 4 to down-regulate your stress response.',
      fullAdvice: 'Used by elite responders and athletes, box breathing resets the autonomic nervous system by stimulating the vagus nerve. Four continuous cycles can lower heart rate and reduce stress hormones within two minutes.',
      readTime: '2 min read',
      icon: Icons.self_improvement_rounded,
      accentColor: Color(0xFFEC4899),
    ),
    HealthTip(
      id: '6',
      title: 'Mindful Satiety Signals',
      category: 'Nutrition',
      description: 'Eat slowly and pause when you feel 80% full (the ancient Okinawan principle of Hara Hachi Bu).',
      fullAdvice: 'It takes approximately 15 to 20 minutes for stomach stretch receptors and leptin signals to notify your brain that you are satisfied. Eating without screens and putting utensils down between bites prevents sluggishness and overeating.',
      readTime: '3 min read',
      icon: Icons.spa_rounded,
      accentColor: Color(0xFF059669),
    ),
    HealthTip(
      id: '7',
      title: 'Hydrate Before You Caffeinate',
      category: 'Hydration',
      description: 'Drink at least one tall glass of water before having your morning coffee or tea.',
      fullAdvice: 'Caffeine has a mild diuretic property. Drinking water first safeguards your blood volume and prevents morning headaches, giving you sustained energy rather than sudden jittery spikes.',
      readTime: '2 min read',
      icon: Icons.local_drink_rounded,
      accentColor: Color(0xFF0284C7),
    ),
    HealthTip(
      id: '8',
      title: 'Consistency Beats Intensity',
      category: 'Exercise',
      description: 'Twenty minutes of daily movement creates stronger physiological adaptations than one exhausting weekend workout.',
      fullAdvice: 'Habit momentum is the key to lifetime fitness. Simple daily bodyweight circuits, brisk walks, stretching, or bike rides sustain cardiovascular resilience and protect joints much better than sporadic overtraining.',
      readTime: '3 min read',
      icon: Icons.fitness_center_rounded,
      accentColor: Color(0xFF2563EB),
    ),
  ];
}
