import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'state/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/symptoms_screen.dart';
import 'screens/grounding_screen.dart';
import 'screens/reassurance_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/daily_check_in_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/relief_tab_screen.dart';
import 'screens/user_tab_screen.dart';
import 'widgets/physiological_sigh.dart';
import 'widgets/somatic_shaking.dart';
import 'widgets/sensory_shock.dart';
import 'widgets/pmr_guide.dart';
import 'widgets/breathing_circle.dart';



void main() {
  runApp(const SolaApp());
}

class SolaApp extends StatefulWidget {
  const SolaApp({super.key});

  @override
  State<SolaApp> createState() => _SolaAppState();
}

class _SolaAppState extends State<SolaApp> {
  // Centralized Application State
  final SolaAppState _appState = SolaAppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sola',
      debugShowCheckedModeBanner: false,
      
      // Core Typography & Material 3 Theme Design
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: SolaColors.sagePrimary,
        colorScheme: const ColorScheme.light(
          primary: SolaColors.sagePrimary,
          secondary: SolaColors.slatePrimary,
          background: SolaColors.bgMain,
          surface: SolaColors.bgCard,
          onPrimary: Colors.white,
          error: SolaColors.coralSoft,
        ),
        fontFamily: 'Outfit',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
          bodyMedium: TextStyle(color: SolaColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      
      home: ListenableBuilder(
        listenable: _appState,
        builder: (context, child) {
          final String screen = _appState.currentScreen;
          
          // Determine if we should show the bottom navigation bar
          // We show it on the four primary views: home, relief, journal, user
          final bool showNavBar = (screen == 'home' || screen == 'relief' || screen == 'journal' || screen == 'user');

          
          return Scaffold(
            backgroundColor: SolaColors.bgMain,
            
            // Central Screen Transition Switcher
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              
              // Premium Fade-Up Slide Page Transition
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.04), // Gentle slide up physics
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              
              // ValueKey forces animation to run on screen swap
              child: KeyedSubtree(
                key: ValueKey<String>(screen),
                child: _buildScreen(screen),
              ),
            ),
            
            // Bottom Navigation Bar (Shown only on primary views)
            bottomNavigationBar: showNavBar
                ? Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x082B332F),
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        )
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _appState.currentTab,
                      onTap: (index) => _appState.setTab(index),
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedItemColor: SolaColors.sagePrimary,
                      unselectedItemColor: SolaColors.textMuted,
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      elevation: 0,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.spa_outlined, size: 22),
                          activeIcon: Icon(Icons.spa, size: 22),
                          label: 'Grounding',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.healing_outlined, size: 22),
                          activeIcon: Icon(Icons.healing, size: 22),
                          label: 'Relief',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.book_outlined, size: 22),
                          activeIcon: Icon(Icons.book, size: 22),
                          label: 'Journal',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline, size: 22),
                          activeIcon: Icon(Icons.person, size: 22),
                          label: 'Me',
                        ),
                      ],

                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  // Navigational Screen Factory
  Widget _buildScreen(String screenName) {
    switch (screenName) {
      case 'home':
        return HomeScreen(appState: _appState);
      case 'symptoms':
        return SymptomsScreen(appState: _appState);
      case 'grounding':
        return GroundingScreen(appState: _appState);
      case 'reassurance':
        return ReassuranceScreen(appState: _appState);
      case 'reflection':
        return ReflectionScreen(appState: _appState);
      case 'relief':
        return ReliefTabScreen(appState: _appState);
      case 'user':
        return UserTabScreen(appState: _appState);
      case 'settings':
        return SettingsScreen(appState: _appState);
      case 'daily_check_in':
        return DailyCheckInScreen(appState: _appState);
      case 'journal':
        return JournalScreen(appState: _appState);
      case 'sigh_breather':
        return PhysiologicalSighBreather(appState: _appState, onExit: () => _appState.navigateTo('home'));
      case 'box_breather':
        return AnimatedBreathingCircle(isImmersive: true, appState: _appState, onExit: () => _appState.navigateTo('home'));

      case 'shaking_exercise':
        return SomaticShakingExercise(onExit: () => _appState.navigateTo('home'));
      case 'pmr_guide':
        return PmrGuide(onExit: () => _appState.navigateTo('home'));
      case 'sensory_shock':
        return SensoryShockGuide(onExit: () => _appState.navigateTo('home'));
      default:
        return HomeScreen(appState: _appState);


    }
  }
}
