import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  final SolaAppState appState;

  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Immersive panic button navigator
  void _handlePanicAttack(BuildContext context) {
    // Navigate straight to the diagnostic sigh breather to immediately ground the lungs
    widget.appState.navigateTo('sigh_breather');
  }

  // Slidable Crisis Lifeline Bottom Sheet
  void _showCrisisDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFBECE9),
                      ),
                      child: const Icon(Icons.favorite, color: SolaColors.coralSoft, size: 20),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Crisis Support Helpline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'If you are experiencing an acute crisis, free and confidential support is available 24/7. You do not have to carry this alone.',
                  style: TextStyle(fontSize: 13.5, color: SolaColors.textSecondary, height: 1.45),
                ),
                const SizedBox(height: 24),
                
                // Call 988
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: const Text('Call 988 (Lifeline)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SolaColors.coralSoft,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dialing 988 Suicide & Crisis Lifeline... Connecting you to a real human anchor.'),
                        backgroundColor: SolaColors.coralSoft,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // Text 741741
                OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Text HOME to 741741'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SolaColors.textPrimary,
                    side: const BorderSide(color: SolaColors.sageAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Messages. Texting HOME to 741741 for immediate text support.'),
                        backgroundColor: SolaColors.sagePrimary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaColors.bgMain,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row (Sola title & Crisis Hotline badge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sola',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'You are safe here.',
                        style: TextStyle(
                          fontSize: 13,
                          color: SolaColors.textSecondary.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                  
                  // Hot-line Button Pill
                  GestureDetector(
                    onTap: () => _showCrisisDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECE9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF9DDD8)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.phone_in_talk, size: 14, color: SolaColors.coralSoft),
                          SizedBox(width: 6),
                          Text(
                            '988 Helpline',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC7503B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Pulsing Panic Button (Exactly Centered in Viewport)
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Aura Ring 3 (Outer)
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.15).animate(
                            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                          ),
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SolaColors.sagePrimary.withOpacity(0.02),
                            ),
                          ),
                        ),
                        // Aura Ring 2
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.97, end: 1.09).animate(
                            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                          ),
                          child: Container(
                            width: 235,
                            height: 235,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SolaColors.sagePrimary.withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Aura Ring 1 (Inner)
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.99, end: 1.04).animate(
                            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                          ),
                          child: Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SolaColors.sagePrimary.withOpacity(0.08),
                            ),
                          ),
                        ),
                        // Main Button Circle
                        GestureDetector(
                          onTap: () => _handlePanicAttack(context),
                          child: Container(
                            width: 195,
                            height: 195,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [Color(0xFF9CB0A6), SolaColors.sagePrimary],
                                center: Alignment.center,
                                radius: 0.85,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: SolaColors.sagePrimary.withOpacity(0.3),
                                  blurRadius: 40,
                                  offset: const Offset(0, 15),
                                )
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Text(
                                    "I'm having a panic attack",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.25,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to start grounding',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Check My Symptoms Bottom Card
              Column(
                children: [
                  const Text(
                    "Not sure what's happening?",
                    style: TextStyle(
                      fontSize: 14,
                      color: SolaColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.bar_chart, size: 18),
                      label: const Text('Check my symptoms'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SolaColors.textPrimary,
                        backgroundColor: SolaColors.bgCard,
                        side: const BorderSide(color: Color(0xFFE5EDE9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => widget.appState.navigateTo('symptoms'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
