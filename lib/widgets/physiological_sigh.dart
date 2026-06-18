import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../theme/colors.dart';
import '../state/app_state.dart';


class PhysiologicalSighBreather extends StatefulWidget {
  final SolaAppState appState;
  final VoidCallback onExit;

  const PhysiologicalSighBreather({
    super.key,
    required this.appState,
    required this.onExit,
  });

  @override
  State<PhysiologicalSighBreather> createState() => _PhysiologicalSighBreatherState();
}

class _PhysiologicalSighBreatherState extends State<PhysiologicalSighBreather>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // Spacious 12-second physiological sigh cycle
    )..repeat();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 60), _showCheckInDialog);
  }

  void _showCheckInDialog() {
    if (!mounted) return;
    
    // Pause the breathing animation while checking in to keep the screen static
    _controller.stop();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Check In",
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: SolaColors.bgCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: SolaColors.sageAccent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: SolaColors.sageAccent,
                    ),
                    child: const Icon(Icons.spa, color: SolaColors.sagePrimary, size: 24),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'How are you feeling now?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SolaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Slowing your breath is highly effective at resetting your nervous system. Would you like to continue breathing, or are you ready to reflect?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: SolaColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Option 1: I feel calmer -> Go to Reflection
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SolaColors.sagePrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog
                      widget.appState.navigateTo('reflection'); // Navigate to reflection screen
                    },
                    child: const Text(
                      'Ready to Reflect',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Option 2: I need more time -> Keep Breathing
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SolaColors.textPrimary,
                      side: const BorderSide(color: Color(0xFFE5EDE9)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog
                      _controller.repeat(); // Resume animation
                      _startTimer(); // Restart the 60-second timer
                    },
                    child: const Text(
                      'Keep Breathing',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // Map the 12-second progress (0.0 to 1.0) to sigh phases
  Map<String, dynamic> _getSighData(double value) {
    // 1. Calculate a mathematically perfect, ultra-smooth organic sine wave for the scale.
    // This completely eliminates any sudden speed shifts or visual jerks at phase boundaries!
    final double angle = value * 2 * 3.141592653589793 - (3.141592653589793 / 2);
    final double scale = 1.05 + 0.2 * math.sin(angle); // Soothingly ranges from 0.85 to 1.25

    // 2. Keep background and circle colors completely static and low-stimulation
    final Color bgColor = SolaColors.bgMain;
    final Color circleColor = SolaColors.sageLight;

    if (value < 0.3333) {
      // First Inhale: 0s to 4s
      double progress = value / 0.3333;
      int displaySeconds = (4.0 - (progress * 4.0)).ceil().clamp(1, 4);
      return {
        'phase': 'inhale1',
        'guide': 'Take a deep breath in through your nose...',
        'scale': scale,
        'seconds': displaySeconds.toString(),
        'color': bgColor,
        'circleColor': circleColor,
      };
    } else if (value < 0.5) {
      // Second Quick Inhale: 4s to 6s
      double progress = (value - 0.3333) / 0.1667;
      int displaySeconds = (2.0 - (progress * 2.0)).ceil().clamp(1, 2);
      return {
        'phase': 'inhale2',
        'guide': 'Now take one more quick, sharp breath in...',
        'scale': scale,
        'seconds': displaySeconds.toString(),
        'color': bgColor,
        'circleColor': circleColor,
      };
    } else {
      // Extended Sigh Exhale: 6s to 12s
      double progress = (value - 0.5) / 0.5;
      int displaySeconds = (6.0 - (progress * 6.0)).ceil().clamp(1, 6);
      return {
        'phase': 'exhale',
        'guide': 'Let out a long, slow, relaxed sigh through your mouth...',
        'scale': scale,
        'seconds': displaySeconds.toString(),
        'color': bgColor,
        'circleColor': circleColor,
      };
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final data = _getSighData(_controller.value);
        final double scale = data['scale'];
        final String seconds = data['seconds'];
        final String guide = data['guide'];

        final Color bgColor = data['color'] ?? SolaColors.bgMain;
        final Color circleColor = data['circleColor'] ?? SolaColors.sageAccent;

        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              // Close Button
              Positioned(
                top: 50,
                right: 24,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28, color: SolaColors.textSecondary),
                  onPressed: widget.onExit,
                ),
              ),
              
              // Main Visualizer
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Physiological Sigh',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The fastest way to ease respiratory panic',
                      style: TextStyle(
                        fontSize: 14,
                        color: SolaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Pulsing Circles Stack
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer aura
                          Transform.scale(
                            scale: scale * 1.12,
                            child: Container(
                              width: 210,
                              height: 210,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SolaColors.sagePrimary.withOpacity(0.06),
                              ),
                            ),
                          ),
                          // Core Circle
                          Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: circleColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: SolaColors.sagePrimary.withOpacity(0.12),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  seconds,
                                  style: const TextStyle(
                                    fontSize: 64, // Large, serene and elegant
                                    fontWeight: FontWeight.w200, // Soothing light weight
                                    color: SolaColors.textPrimary,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Interactive guides
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        guide,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: SolaColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
