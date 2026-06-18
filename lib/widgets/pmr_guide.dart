import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/colors.dart';

class PmrGuide extends StatefulWidget {
  final VoidCallback onExit;

  const PmrGuide({super.key, required this.onExit});

  @override
  State<PmrGuide> createState() => _PmrGuideState();
}

class _PmrGuideState extends State<PmrGuide> {
  int _currentStep = 0; // 0 = Hands, 1 = Shoulders, 2 = Abdomen, 3 = Feet
  Timer? _countdownTimer;
  int _secondsLeft = 5;
  String _phase = 'ready'; // 'ready', 'clench', 'release', 'done'
  
  final List<Map<String, String>> _stepsData = [
    {
      'title': 'Hands & Fists',
      'instruction': 'Squeeze both hands into tight, solid fists as hard as you can.',
      'tenseTip': 'Feel the tension building in your fingers, knuckles, and forearms...',
      'releaseTip': 'Now relax. Let your fingers spread wide. Feel the warmth and release of blood flow.',
    },
    {
      'title': 'Shoulders & Neck',
      'instruction': 'Shrug your shoulders all the way up to your ears, tensing your neck.',
      'tenseTip': 'Hold the tightness in your upper back and neck. Squeeze tightly...',
      'releaseTip': 'Drop them completely. Let your shoulders fall heavy. Feel the tension melt away.',
    },
    {
      'title': 'Abdomen & Core',
      'instruction': 'Tighten your stomach muscles as if you are bracing for impact.',
      'tenseTip': 'Squeeze your abdominal wall tightly. Feel the solid tension...',
      'releaseTip': 'Let your stomach go soft. Take a deep, relaxed belly breath. Let it expand.',
    },
    {
      'title': 'Toes & Feet',
      'instruction': 'Curl your toes down tightly and squeeze the arches of your feet.',
      'tenseTip': 'Feel the tight cramps and tension in your soles. Squeeze...',
      'releaseTip': 'Release. Wiggle your toes. Let your feet lie flat and heavy on the floor.',
    },
  ];

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startStepSequence() {
    // Phase 1: Clench
    setState(() {
      _phase = 'clench';
      _secondsLeft = 5;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        _startReleaseSequence();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _startReleaseSequence() {
    // Phase 2: Release
    setState(() {
      _phase = 'release';
      _secondsLeft = 5;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _phase = 'done';
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
      _phase = 'ready';
      _secondsLeft = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastStep = _currentStep == _stepsData.length - 1;
    final stepData = _stepsData[_currentStep];

    // Dynamic styles based on clench vs release
    Color timerBgColor = SolaColors.bgMain;
    Color timerBorderColor = SolaColors.sageAccent;
    String timerStatusText = 'Ready';
    Color timerTextColor = SolaColors.textPrimary;

    if (_phase == 'clench') {
      timerBgColor = const Color(0xFFFDEEEB); // Warm orange alert
      timerBorderColor = SolaColors.coralSoft;
      timerStatusText = 'CLENCH!';
      timerTextColor = SolaColors.coralSoft;
    } else if (_phase == 'release') {
      timerBgColor = SolaColors.sageLight; // Soothing green
      timerBorderColor = SolaColors.sagePrimary;
      timerStatusText = 'RELEASE';
      timerTextColor = SolaColors.sagePrimary;
    } else if (_phase == 'done') {
      timerBgColor = SolaColors.slateAccent;
      timerBorderColor = SolaColors.slatePrimary;
      timerStatusText = 'Done';
      timerTextColor = SolaColors.slatePrimary;
    }

    return Scaffold(
      backgroundColor: SolaColors.bgMain,
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
          
          // Main Body
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Muscle Relaxation',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'PMR: Release somatic tension group by group',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: SolaColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Progress Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_stepsData.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentStep
                              ? SolaColors.sagePrimary
                              : (index < _currentStep ? SolaColors.slatePrimary : Colors.white),
                          border: Border.all(color: SolaColors.sageAccent),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),

                  // Interactive Muscle Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x042B332F),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Step ${_currentStep + 1} of 4: ${stepData['title']}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: SolaColors.sagePrimary, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          stepData['instruction']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SolaColors.textPrimary, height: 1.3),
                        ),
                        const SizedBox(height: 30),

                        // Circle Timer Indicator
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: timerBgColor,
                              border: Border.all(color: timerBorderColor, width: 5),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _phase == 'ready' ? 'Ready' : '$_secondsLeft s',
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: timerTextColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    timerStatusText,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: timerTextColor, letterSpacing: 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Phase Specific Tips
                        MinHeightText(
                          text: _phase == 'clench'
                              ? stepData['tenseTip']!
                              : (_phase == 'release' ? stepData['releaseTip']! : 'Prepare yourself. Take a deep breath.'),
                          style: const TextStyle(fontSize: 14, color: SolaColors.textSecondary, height: 1.45, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Control CTA Buttons
                  if (_phase == 'ready')
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SolaColors.slatePrimary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _startStepSequence,
                        child: const Text('Start Clench', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (_phase == 'done' && !isLastStep)
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SolaColors.sagePrimary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _nextStep,
                        child: const Text('Next Muscle Group', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (_phase == 'done' && isLastStep)
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SolaColors.sagePrimary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: widget.onExit,
                        child: const Text('Complete PMR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small helper widget to keep text height consistent and prevent layout jumps
class MinHeightText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const MinHeightText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}
