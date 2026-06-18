import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  final SolaAppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: SolaColors.bgMain,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: SolaColors.textSecondary),
                        onPressed: () => appState.navigateTo('user'),
                      ),

                      const SizedBox(width: 16),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Settings Rows
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User Profile Header Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: SolaColors.bgCardAlt,
                            border: Border.all(color: const Color(0xFFF0E5DC)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SolaColors.sageLight,
                                ),
                                child: const Center(
                                  child: Text(
                                    'AR',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Profile details
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alex Rivera',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: SolaColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Pro Member since June 2023',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: SolaColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Daily Support Section
                        _buildSectionHeader('DAILY SUPPORT'),
                        Container(
                          decoration: _buildBoxDecoration(),
                          child: Column(
                            children: [
                              // Daily Check-ins Switch
                              _buildSwitchTile(
                                title: 'Daily Check-ins',
                                subtitle: 'Gentle reminders to log your mood',
                                value: appState.dailyCheckinsEnabled,
                                onChanged: (val) => appState.toggleDailyCheckins(val),
                              ),
                              const Divider(height: 1, color: Color(0x18768A7E)),
                              // Panic Support Switch
                              _buildSwitchTile(
                                title: 'Panic Support Alerts',
                                subtitle: 'Quick access during high anxiety',
                                value: appState.panicAlertsEnabled,
                                onChanged: (val) => appState.togglePanicAlerts(val),
                              ),
                              const Divider(height: 1, color: Color(0x18768A7E)),
                              // Reminder Time Picker
                              _buildArrowTile(
                                title: 'Reminder Time',
                                subtitle: 'Scheduled for ${appState.reminderTime}',
                                icon: Icons.access_time,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // App Preferences Section
                        _buildSectionHeader('APP PREFERENCES'),
                        Container(
                          decoration: _buildBoxDecoration(),
                          child: Column(
                            children: [
                              _buildArrowTile(
                                title: 'Security Lock',
                                subtitle: 'FaceID or Passcode',
                                icon: Icons.lock_outline,
                                onTap: () {},
                              ),
                              const Divider(height: 1, color: Color(0x18768A7E)),
                              _buildArrowTile(
                                title: 'Breathing Pace',
                                subtitle: 'Set your comfortable rhythm',
                                icon: Icons.air,
                                onTap: () {},
                              ),
                              const Divider(height: 1, color: Color(0x18768A7E)),
                              _buildArrowTile(
                                title: 'Haptic Feedback',
                                subtitle: 'Soft tactile grounding pulses',
                                icon: Icons.vibration,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Support Section
                        _buildSectionHeader('SUPPORT'),
                        Container(
                          decoration: _buildBoxDecoration(),
                          child: Column(
                            children: [
                              _buildArrowTile(
                                title: 'Help Center',
                                subtitle: 'Guides & grounding tutorials',
                                icon: Icons.help_outline,
                                onTap: () {},
                              ),
                              const Divider(height: 1, color: Color(0x18768A7E)),
                              _buildArrowTile(
                                title: 'Privacy Policy',
                                subtitle: 'How we protect your data',
                                icon: Icons.privacy_tip_outlined,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Log Out Button
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF3EFE9), // Light gray background
                              foregroundColor: SolaColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              appState.navigateTo('home');
                            },
                            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // App Version Footer
                        const Center(
                          child: Text(
                            'Sola v2.4.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: SolaColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Section header helper
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: SolaColors.textSecondary,
        ),
      ),
    );
  }

  // Box decoration for grouped list items
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x032B332F),
          blurRadius: 15,
          offset: Offset(0, 8),
        )
      ],
    );
  }

  // Switch row builder
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SolaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: SolaColors.slatePrimary,
            activeTrackColor: SolaColors.slateAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE5EDE9),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  // Navigation Arrow row builder
  Widget _buildArrowTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Makes whole area clickable
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: SolaColors.bgMain,
              ),
              child: Icon(icon, color: SolaColors.textSecondary, size: 18),
            ),
            const SizedBox(width: 14),
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: SolaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: SolaColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            const Icon(Icons.chevron_right, color: SolaColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
