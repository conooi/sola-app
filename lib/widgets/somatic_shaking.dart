import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../theme/colors.dart';

class SomaticShakingExercise extends StatefulWidget {
  final VoidCallback onExit;

  const SomaticShakingExercise({super.key, required this.onExit});

  @override
  State<SomaticShakingExercise> createState() => _SomaticShakingExerciseState();
}

class _SomaticShakingExerciseState extends State<SomaticShakingExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _wobbleController;
  Timer? _countdownTimer;
  int _secondsLeft = 60;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Looping wobble controller to shake the visual container
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
  }

  @override
  void dispose() {
    _wobbleController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
    });
    _wobbleController.repeat(reverse: true);
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        // Finished!
        timer.cancel();
        _wobbleController.stop();
        setState(() {
          _secondsLeft = 0;
          _isRunning = false;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  // Phased instructions based on countdown seconds
  String _getSomaticInstruction() {
    if (!_isRunning && _secondsLeft == 60) {
      return "Ready to shake the adrenaline out? Press start, loosen your muscles, and follow the guide.";
    }
    if (_secondsLeft == 0) {
      return "Stop. Rest in complete stillness. Close your eyes, take a slow breath, and feel the tingling settle in your body. You are safe.";
    }
    if (_secondsLeft > 45) {
      return "Phase 1: Loose wrists. Start shaking your hands and fingers. Let them go completely floppy.";
    }
    if (_secondsLeft > 30) {
      return "Phase 2: Now shake your arms and elbows. Loosen your shoulders. Let your chest bounce.";
    }
    if (_secondsLeft > 15) {
      return "Phase 3: Bounce your heels. Shake your thighs and legs. Feel the stress draining down to the earth.";
    }
    return "Phase 4: Shake your whole body! Loosen your jaw. Let the wave of adrenaline fully release.";
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _secondsLeft == 0;
    
    return Scaffold(
      backgroundColor: isCompleted 
          ? SolaColors.sageAccent // Sola quiet green upon completion
          : const Color(0xFFFDF0ED), // Adrenaline warm pink during exercise
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Somatic Release',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SolaColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Physically release excess adrenaline',
                    style: TextStyle(
                      fontSize: 14,
                      color: SolaColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Pulsing & Shaking Timer Box
                Center(
                  child: AnimatedBuilder(
                    animation: _wobbleController,
                    builder: (context, child) {
                      // Generate a wobbly offset if running
                      double wobbleOffset = 0.0;
                      if (_isRunning) {
                        wobbleOffset = math.sin(_wobbleController.value * 2 * math.pi) * 6.0;
                      }

                      return Transform.translate(
                        offset: Offset(wobbleOffset, wobbleOffset),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted 
                                ? SolaColors.sageLight 
                                : (_isRunning ? SolaColors.coralSoft : Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: (_isRunning ? SolaColors.coralSoft : SolaColors.textMuted).withOpacity(0.15),
                                blurRadius: 35,
                                offset: const Offset(0, 15),
                              )
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCompleted ? Icons.spa : Icons.vibration, 
                                  color: isCompleted ? Colors.white : SolaColors.textPrimary, 
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isCompleted ? 'Stillness' : '$_secondsLeft',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted ? Colors.white : SolaColors.textPrimary,
                                  ),
                                ),
                                if (!isCompleted && _isRunning)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'SHAKE',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: SolaColors.textSecondary),
                                    ),
                                  ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),

                // Somatic Phased Instructions Box
                Container(
                  constraints: const BoxConstraints(minHeight: 80),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getSomaticInstruction(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: SolaColors.textPrimary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Control Button
                if (!_isRunning && _secondsLeft == 60)
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SolaColors.slatePrimary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _startExercise,
                      child: const Text('Start Shaking Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (isCompleted)
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SolaColors.sagePrimary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: widget.onExit,
                      child: const Text('I Feel Calmer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
