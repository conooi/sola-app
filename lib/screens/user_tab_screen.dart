import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';
import 'journey_screen.dart';
import 'safe_circle_screen.dart';

class UserTabScreen extends StatefulWidget {
  final SolaAppState appState;

  const UserTabScreen({super.key, required this.appState});

  @override
  State<UserTabScreen> createState() => _UserTabScreenState();
}

class _UserTabScreenState extends State<UserTabScreen> {
  int _activeSubTab = 0; // 0 = My Journey, 1 = Safe Circle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaColors.bgMain,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Profile Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  // User Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [SolaColors.sagePrimary, SolaColors.slatePrimary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'AR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Profile info
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
                          'Resilience Builder',
                          style: TextStyle(
                            fontSize: 12,
                            color: SolaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Settings Gear Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: SolaColors.sageAccent.withOpacity(0.6)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.settings_outlined, size: 20, color: SolaColors.textSecondary),
                      onPressed: () {
                        widget.appState.navigateTo('settings');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Sliding Segment Control Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: SolaColors.sageAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    // Segment 1: My Journey
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeSubTab = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _activeSubTab == 0 ? SolaColors.slatePrimary : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '📈 My Journey',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _activeSubTab == 0 ? Colors.white : SolaColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Segment 2: Safe Circle
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeSubTab = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _activeSubTab == 1 ? SolaColors.slatePrimary : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '🛡️ Safe Circle',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _activeSubTab == 1 ? Colors.white : SolaColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Sub-tab content switcher
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey<int>(_activeSubTab),
                  child: _buildSubTabContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Returns the appropriate sub-widget (stripped of scaffolding headers)
  Widget _buildSubTabContent() {
    if (_activeSubTab == 0) {
      return JourneyScreen(appState: widget.appState);
    } else {
      return SafeCircleScreen(appState: widget.appState);
    }
  }
}

