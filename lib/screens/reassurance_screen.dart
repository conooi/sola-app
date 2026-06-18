import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class ReassuranceScreen extends StatelessWidget {
  final SolaAppState appState;

  const ReassuranceScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: SolaColors.textSecondary),
                    onPressed: () => appState.navigateTo('home'),
                  ),
                  const Text(
                    'Reassurance Hub',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SolaColors.textPrimary,
                    ),
                  ),
                  // Safe Home Escape Hatch
                  IconButton(
                    icon: const Icon(Icons.home_outlined, color: SolaColors.textSecondary),
                    onPressed: () => appState.navigateTo('home'),
                  ),

                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Reassurance Block
                    const Text(
                      'You are safe.',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Panic is a physical response, not a physical danger. Let's remind your body of that.",
                      style: TextStyle(
                        fontSize: 14,
                        color: SolaColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Calming Truths Section
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CALMING TRUTHS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: SolaColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Swipe for more',
                          style: TextStyle(
                            fontSize: 11,
                            color: SolaColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Carousel
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildTruthCard(
                            icon: Icons.star_border,
                            text: 'This feeling is temporary. It has a beginning, a middle, and an end. You are in the middle right now, and the end is coming.',
                          ),
                          const SizedBox(width: 14),
                          _buildTruthCard(
                            icon: Icons.favorite_border,
                            text: 'Your heart is beating fast to protect you, not to hurt you. It is a sign of a healthy, strong body.',
                          ),
                          const SizedBox(width: 14),
                          _buildTruthCard(
                            icon: Icons.shield_outlined,
                            text: 'You have survived 100% of your panic attacks. You are capable of moving through this one too.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Understanding the Body Section
                    const Text(
                      'UNDERSTANDING THE BODY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: SolaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Accordion 1
                    const AccordionCard(
                      title: 'The Adrenaline Spike',
                      content: 'During panic, your brain releases adrenaline. It feels intense, but adrenaline is naturally reabsorbed by your body within minutes. This wave will break and dissolve naturally.',
                    ),
                    const SizedBox(height: 10),

                    // Accordion 2
                    const AccordionCard(
                      title: 'Hyperventilation',
                      content: 'Feeling short of breath is often caused by taking in too much oxygen, not too little. Slowing down your exhale and prolonging it signals your nervous system that it is safe to relax.',
                    ),
                    const SizedBox(height: 10),

                    // Accordion 3
                    const AccordionCard(
                      title: 'The "False Alarm"',
                      content: 'A panic attack is like a smoke detector going off because of toast—the alarm is extremely loud and scary, but there is no actual fire in the house. Your body is reacting to a false alarm.',
                    ),
                    const SizedBox(height: 20),

                    // Soft Footer Note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.spa, size: 16, color: SolaColors.sagePrimary.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        const Text(
                          'Take all the time you need.',
                          style: TextStyle(
                            fontSize: 12,
                            color: SolaColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Action Panel
            Container(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 34.0),
              decoration: const BoxDecoration(
                color: SolaColors.bgCardAlt,
                border: Border(
                  top: BorderSide(color: Color(0x18768A7E), width: 1),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Ready to try a technique?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: SolaColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Breathing button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: SolaColors.textPrimary,
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFE5EDE9)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Direct navigation to grounding
                              appState.navigateTo('grounding');
                            },
                            child: const Text('Breathing'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Grounding button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SolaColors.sagePrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () => appState.navigateTo('grounding'),
                            child: const Text('Grounding'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Carousel Card builder
  Widget _buildTruthCard({required IconData icon, required String text}) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SolaColors.bgCard,
        border: Border.all(color: SolaColors.sageAccent.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x052B332F),
            blurRadius: 15,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: SolaColors.sageAccent,
            ),
            child: Icon(icon, color: SolaColors.sagePrimary, size: 18),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: SolaColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Animated Accordion Widget
class AccordionCard extends StatefulWidget {
  final String title;
  final String content;

  const AccordionCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard> with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOpen = !_isOpen;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: SolaColors.bgCard,
          border: Border.all(
            color: _isOpen ? SolaColors.sagePrimary : SolaColors.sageAccent.withOpacity(0.5),
            width: _isOpen ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x032B332F),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: SolaColors.sagePrimary, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                      ),
                    ),
                  ),
                  // Chevron Icon (rotates smoothly based on state)
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: _isOpen ? SolaColors.sagePrimary : SolaColors.textMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Content Drawer (expands/collapses)
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              child: Container(
                height: _isOpen ? null : 0,
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
                child: Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: SolaColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
