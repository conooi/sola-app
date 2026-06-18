import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/colors.dart';

class SensoryShockGuide extends StatefulWidget {
  final VoidCallback onExit;

  const SensoryShockGuide({super.key, required this.onExit});

  @override
  State<SensoryShockGuide> createState() => _SensoryShockGuideState();
}

class _SensoryShockGuideState extends State<SensoryShockGuide> {
  int _activeOption = 0; // 0 = Ice Shock, 1 = Sour Candy
  Timer? _timer;
  int _secondsLeft = 15;
  bool _isTimerRunning = false;
  bool _isTimerFinished = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startIceTimer() {
    setState(() {
      _isTimerRunning = true;
      _isTimerFinished = false;
      _secondsLeft = 15;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _isTimerRunning = false;
          _isTimerFinished = true;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Soft ice-blue background
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
                      'Shock Your Senses',
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
                      'DBT TIPP Skill: Derailed panic with intense physical input',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: SolaColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Option Selector Tabs
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeOption = 0;
                                _timer?.cancel();
                                _isTimerRunning = false;
                                _isTimerFinished = false;
                                _secondsLeft = 15;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _activeOption == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: _activeOption == 0
                                    ? [const BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))]
                                    : null,
                              ),
                              child: Text(
                                '❄️ Ice Shock',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _activeOption == 0 ? SolaColors.textPrimary : SolaColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeOption = 1;
                                _timer?.cancel();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _activeOption == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: _activeOption == 1
                                    ? [const BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))]
                                    : null,
                              ),
                              child: Text(
                                '🍋 Sour Shock',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _activeOption == 1 ? SolaColors.textPrimary : SolaColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Option Content Card
                  Expanded(
                    flex: 12,
                    child: _activeOption == 0 ? _buildIceShockContent() : _buildSourShockContent(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Option 1: Ice Shock layout with countdown timer
  Widget _buildIceShockContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.ac_unit, size: 44, color: Colors.lightBlue),
          const SizedBox(height: 16),
          const Text(
            'Mammalian Dive Reflex',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hold an ice cube, a cold wet cloth, or splash freezing water on your face, neck, or wrists.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: SolaColors.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 30),

          // Circle Timer
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isTimerRunning ? Colors.lightBlue.shade50 : SolaColors.bgMain,
                border: Border.all(
                  color: _isTimerRunning ? Colors.lightBlue : SolaColors.sageAccent,
                  width: 4,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isTimerFinished ? 'Calm' : '$_secondsLeft s',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
                    ),
                    if (_isTimerRunning)
                      const Text(
                        'HOLD COLD',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Soothing guidance message
          Text(
            _isTimerRunning
                ? 'Your heart rate is dropping. The cold is telling your brain that you are safe.'
                : (_isTimerFinished
                    ? 'Great job. Feel your breathing slow down. The physical shock has successfully broken the panic loop.'
                    : 'Get your ice or cold cloth ready. Press start and hold it to your skin for 15 seconds.'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: SolaColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Control Button
          if (!_isTimerRunning && !_isTimerFinished)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: _startIceTimer,
              child: const Text('Start 15s Hold', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          if (_isTimerFinished)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaColors.sagePrimary,
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onExit,
              child: const Text('I Feel Calmer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  // Option 2: Sour Candy advice
  Widget _buildSourShockContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.bolt, size: 44, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Salivary-Vagal Response',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
          ),
          const SizedBox(height: 12),
          const Text(
            'Put a piece of sour candy (like a Warhead or Lemonhead) directly on your tongue. Try to focus entirely on the sour sensation without chewing.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: SolaColors.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Why it works: The extreme sourness shocks your taste buds, forcing the brain to immediately abandon the panic loop to process the sudden sensory input.',
                    style: TextStyle(fontSize: 11.5, color: SolaColors.textPrimary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
            onPressed: widget.onExit,
            child: const Text('I am focusing on the taste', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
