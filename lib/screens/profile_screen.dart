import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../widgets/disclaimer_card.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _useMetricUnits = true;
  bool _enableNotifications = true;
  bool _enableDailyHydrationPing = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Avatar & Info Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: Color(0xFF059669),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Alex Johnson',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'alex.johnson@example.com',
                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '🌱 Wellness Explorer • Streak: 5 Days',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Quick Metrics / Activity summary
              Row(
                children: [
                  _buildStatCard('14', 'Calculations', Icons.calculate_outlined, const Color(0xFF10B981), isDark),
                  const SizedBox(width: 12),
                  _buildStatCard('85%', 'Hydration Avg', Icons.water_drop_outlined, const Color(0xFF0284C7), isDark),
                  const SizedBox(width: 12),
                  _buildStatCard('5d', 'Active Streak', Icons.local_fire_department_outlined, const Color(0xFFF59E0B), isDark),
                ],
              ),

              const SizedBox(height: 24),

              // Preferences Section
              Text(
                'App Preferences',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 10),

              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Measurement Units Toggle
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.straighten_rounded, color: Color(0xFF10B981), size: 20),
                      ),
                      title: const Text('Metric System (kg, cm)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        _useMetricUnits ? 'Using Kilograms & Centimeters' : 'Using Pounds & Feet/Inches',
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: _useMetricUnits,
                      onChanged: (val) {
                        setState(() => _useMetricUnits = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_useMetricUnits ? 'Switched default to Metric (kg, cm)' : 'Switched default to Imperial (lb, ft)'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1),

                    // Dark Mode Toggle
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: const Color(0xFF6366F1),
                          size: 20,
                        ),
                      ),
                      title: const Text('Dark Mode Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        widget.isDarkMode ? 'Night theme active' : 'Light theme active',
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: widget.isDarkMode,
                      onChanged: (_) => widget.onToggleTheme(),
                    ),

                    const Divider(height: 1),

                    // Notifications Ping
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.water_drop_outlined, color: Color(0xFF0284C7), size: 20),
                      ),
                      title: const Text('Daily Hydration Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Gentle hourly pings to drink water', style: TextStyle(fontSize: 12)),
                      value: _enableDailyHydrationPing,
                      onChanged: (val) {
                        setState(() => _enableDailyHydrationPing = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About & Information Section
              Text(
                'About HealthMate',
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 10),

              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 20),
                      ),
                      title: const Text('App Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('HealthMate v1.0.0 • Flutter Web', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'HealthMate',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2026 HealthMate. General health estimation companion.',
                          children: [
                            const SizedBox(height: 12),
                            const Text(
                              'HealthMate is an offline-ready, responsive Flutter application designed to calculate Body Mass Index, daily water intake goals, energy/caloric requirements, and healthy weight targets.',
                              style: TextStyle(fontSize: 13, height: 1.4),
                            ),
                          ],
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 20),
                      ),
                      title: const Text('Data Privacy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('100% Client-side • Zero data stored or transmitted', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All calculations run entirely in your local browser. No personal data is collected.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const DisclaimerCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
