import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../theme/colors.dart';
import '../state/app_state.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final bool isImmersive;
  final VoidCallback? onExit;
  final SolaAppState? appState;

  const AnimatedBreathingCircle({
    super.key,
    this.isImmersive = false,
    this.onExit,
    this.appState,
  });

  @override
  State<AnimatedBreathingCircle> createState() => _AnimatedBreathingCircleState();
}

class _AnimatedBreathingCircleState extends State<AnimatedBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    if (widget.isImmersive && widget.appState != null) {
      _startTimer();
    }
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
    if (!mounted || widget.appState == null) return;
    
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
                      widget.appState!.navigateTo('reflection'); // Navigate to reflection screen
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

  // Get current phase details based on the 16-second loop progress (0.0 to 1.0)
  Map<String, dynamic> _getPhaseData(double value) {
    // Keep colors completely static and low-stimulation
    final Color bgColor = SolaColors.bgMain;
    final Color circleColor = SolaColors.sageLight;

    if (value < 0.25) {
      // Inhale (0s - 4s)
      double progress = value / 0.25;
      double scale = 0.85 + (0.4 * progress); // Grows from 0.85 to 1.25
      int secondsLeft = 4 - (progress * 4).floor();
      return {
        'phase': 'inhale',
        'text': 'Breathe In',
        'guide': 'Breathe In • Slowly draw in warm, calming air...',
        'scale': scale,
        'secondsLeft': secondsLeft.clamp(1, 4),
        'color': bgColor,
        'circleColor': circleColor,
      };
    } else if (value < 0.50) {
      // Hold In (4s - 8s)
      double progress = (value - 0.25) / 0.25;
      int secondsLeft = 4 - (progress * 4).floor();
      return {
        'phase': 'hold-in',
        'text': 'Hold',
        'guide': 'Hold • Feel the quiet strength inside you...',
        'scale': 1.25, // Stays expanded
        'secondsLeft': secondsLeft.clamp(1, 4),
        'color': bgColor,
        'circleColor': circleColor,
      };
    } else if (value < 0.75) {
      // Exhale (8s - 12s)
      double progress = (value - 0.50) / 0.25;
      double scale = 1.25 - (0.4 * progress); // Shrinks from 1.25 to 0.85
      int secondsLeft = 4 - (progress * 4).floor();
      return {
        'phase': 'exhale',
        'text': 'Breathe Out',
        'guide': 'Breathe Out • Release all the tension and worries...',
        'scale': scale,
        'secondsLeft': secondsLeft.clamp(1, 4),
        'color': bgColor,
        'circleColor': circleColor,
      };
    } else {
      // Hold Out (12s - 16s)
      double progress = (value - 0.75) / 0.25;
      int secondsLeft = 4 - (progress * 4).floor();
      return {
        'phase': 'hold-out',
        'text': 'Hold',
        'guide': 'Hold • Rest in this still, quiet space...',
        'scale': 0.85, // Stays contracted
        'secondsLeft': secondsLeft.clamp(1, 4),
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
        final data = _getPhaseData(_controller.value);
        
        if (widget.isImmersive) {
          return _buildImmersiveView(data);
        } else {
          return _buildSmallView(data);
        }
      },
    );
  }

  // Giant Fullscreen Breathing Circle
  Widget _buildImmersiveView(Map<String, dynamic> data) {
    final double scale = data['scale'];
    final int secondsLeft = data['secondsLeft'];
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
          
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Box Breathing',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Navy SEALs method for nervous system balance',
                  style: TextStyle(
                    fontSize: 14,
                    color: SolaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Pulsing Rings Wrapper
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Aura Ring 1
                      Transform.scale(
                        scale: scale * 1.15,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SolaColors.sagePrimary.withOpacity(0.04),
                          ),
                        ),
                      ),
                      // Aura Ring 2
                      Transform.scale(
                        scale: scale * 1.07,
                        child: Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SolaColors.sagePrimary.withOpacity(0.08),
                          ),
                        ),
                      ),
                      // Core Pulsing Circle
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
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              )
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Dashed Inner Ring
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: SolaColors.sagePrimary.withOpacity(0.2),
                                    style: BorderStyle.solid,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Soothing Minimalist Integer Count
                              Text(
                                '$secondsLeft',
                                style: const TextStyle(
                                  fontSize: 64, // Large, serene and elegant
                                  fontWeight: FontWeight.w200, // Soothing light weight
                                  color: SolaColors.textPrimary,
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Breathing Phrase Guide
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    guide,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: SolaColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  // Small Inline Breathing Card
  Widget _buildSmallView(Map<String, dynamic> data) {
    final String text = data['text'];
    final int secondsLeft = data['secondsLeft'];
    final String phase = data['phase'];
    
    // Scale transitions for the compact banner
    final bool isExpanding = (phase == 'inhale' || phase == 'hold-in');
    final double scale = isExpanding ? 1.04 : 0.98;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isExpanding ? SolaColors.sageLight : SolaColors.sageAccent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: Alignment.center,
        child: Text(
          '$text ($secondsLeft s)',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SolaColors.textPrimary,
          ),
        ),
      ),
    );
  }

}
