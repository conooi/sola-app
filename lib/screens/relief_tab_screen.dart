import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';
import '../widgets/physiological_sigh.dart';
import '../widgets/somatic_shaking.dart';
import '../widgets/sensory_shock.dart';
import '../widgets/pmr_guide.dart';

class ReliefTabScreen extends StatelessWidget {
  final SolaAppState appState;

  const ReliefTabScreen({super.key, required this.appState});

  // Dialog Launchers
  void _showImmersiveBreather(BuildContext context) {
    appState.navigateTo('box_breather'); // Fullscreen immersive route
  }


  void _showSighBreather(BuildContext context) {
    appState.navigateTo('sigh_breather');
  }

  void _showShakingExercise(BuildContext context) {
    appState.navigateTo('shaking_exercise');
  }

  void _showSensoryShock(BuildContext context) {
    appState.navigateTo('sensory_shock');
  }

  void _showPmrGuide(BuildContext context) {
    appState.navigateTo('pmr_guide');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final hasSymptoms = appState.selectedSymptoms.isNotEmpty;

        return Scaffold(
          backgroundColor: SolaColors.bgMain,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSymptoms ? 'Tailored Remedies' : 'Relief Library',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasSymptoms 
                            ? 'Exercises curated specifically for your active symptoms' 
                            : 'Explore evidence-based somatic & breathing exercises',
                        style: const TextStyle(
                          fontSize: 13,
                          color: SolaColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Exercises List
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasSymptoms) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ACTIVE RECOMMENDATIONS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: SolaColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => appState.clearSymptoms(),
                                child: const Text(
                                  'Clear Curation',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: SolaColors.sagePrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        ..._buildDynamicRemedies(context),
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

  // Reusable Relief Cards
  Widget _buildReliefCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SolaColors.bgCard,
          border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x042B332F),
              blurRadius: 12,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
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
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: SolaColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamic Remedies Curation Engine
  List<Widget> _buildDynamicRemedies(BuildContext context) {
    final selected = appState.selectedSymptoms;
    
    // Core Remedy Cards
    final slowBreathCard = _buildReliefCard(
      title: 'Slow your breath (Box Breathing)',
      desc: 'Inhale 4s, hold 4s, exhale 4s, hold 4s. Instantly syncs cardiac rhythm.',
      icon: Icons.air,
      iconBgColor: SolaColors.sageAccent,
      iconColor: SolaColors.sagePrimary,
      onTap: () => _showImmersiveBreather(context),
    );

    final physiologicalSighCard = _buildReliefCard(
      title: 'Physiological Sigh',
      desc: 'Double inhale, extended exhale. The fastest way to open airways and slow racing pulse.',
      icon: Icons.compress,
      iconBgColor: SolaColors.slateAccent,
      iconColor: SolaColors.slatePrimary,
      onTap: () => _showSighBreather(context),
    );

    final somaticShakingCard = _buildReliefCard(
      title: 'Move & Release (Somatic Shaking)',
      desc: 'Walk briskly, stretch, or shake. Discharges adrenaline priming your limbs, relieving tremors.',
      icon: Icons.directions_run,
      iconBgColor: const Color(0xFFFBECE9),
      iconColor: SolaColors.coralSoft,
      onTap: () => _showShakingExercise(context),
    );

    final grounding54321Card = _buildReliefCard(
      title: 'Find 5 things (5-4-3-2-1 Grounding)',
      desc: 'List sights, touches, sounds, and smells. Anchors mind away from racing panic thoughts.',
      icon: Icons.visibility_outlined,
      iconBgColor: SolaColors.pinkAccent,
      iconColor: SolaColors.slatePrimary,
      onTap: () => appState.navigateTo('grounding'),
    );

    final comfortingTruthsCard = _buildReliefCard(
      title: 'Comforting Truths',
      desc: 'Read scientific facts about panic. Reassures your brain that you are 100% safe.',
      icon: Icons.shield_outlined,
      iconBgColor: const Color(0xFFECEFF1),
      iconColor: Colors.blueGrey,
      onTap: () => appState.navigateTo('reassurance'),
    );

    final sensoryShockCard = _buildReliefCard(
      title: 'Shock Your Senses (TIPP)',
      desc: 'Eat sour candy or hold ice on your wrists/neck. Intense physical shock derails panic instantly.',
      icon: Icons.bolt,
      iconBgColor: const Color(0xFFFFF8E1), // Lemon-yellow Sour Candy shock
      iconColor: Colors.amber.shade800,
      onTap: () => _showSensoryShock(context),
    );

    final pmrCard = _buildReliefCard(
      title: 'Muscle Relaxation (PMR)',
      desc: 'Clench and release muscle groups step-by-step. Directly relieves physical shaking & tremors.',
      icon: Icons.accessibility_new,
      iconBgColor: const Color(0xFFEDE7F6), // Lavender PMR
      iconColor: Colors.deepPurple,
      onTap: () => _showPmrGuide(context),
    );

    // If no symptoms are selected, show general curated relief list
    if (selected.isEmpty) {
      return [
        slowBreathCard,
        physiologicalSighCard,
        somaticShakingCard,
        grounding54321Card,
        comfortingTruthsCard,
        sensoryShockCard,
        pmrCard,
      ];
    }

    // Build tailored list based on symptom categories
    final List<Widget> tailoredRemedies = [];

    final hasRespiratory = selected.contains('sym_heart_rapid') || 
                           selected.contains('sym_breath_short') || 
                           selected.contains('sym_breath_short_2');

    final hasSomatic = selected.contains('sym_trembling') || 
                        selected.contains('sym_numbness') || 
                        selected.contains('sym_nausea');

    final hasCognitive = selected.contains('sym_racing_thoughts') || 
                          selected.contains('sym_fear_control') || 
                          selected.contains('sym_detached') ||
                          selected.contains('sym_detached_emotional') ||
                          selected.contains('sym_fear_control_2') ||
                          selected.contains('sym_catastrophizing');

    if (hasRespiratory) {
      tailoredRemedies.add(_buildSectionBadge('TARGETS RACING HEART & CHEST TIGHTNESS'));
      tailoredRemedies.add(const SizedBox(height: 8));
      tailoredRemedies.add(physiologicalSighCard);
      tailoredRemedies.add(slowBreathCard);
      tailoredRemedies.add(pmrCard); // Chest tightness relief
      tailoredRemedies.add(const SizedBox(height: 16));
    }

    if (hasSomatic) {
      tailoredRemedies.add(_buildSectionBadge('TARGETS SHAKING & TINGLING SENSATIONS'));
      tailoredRemedies.add(const SizedBox(height: 8));
      tailoredRemedies.add(somaticShakingCard);
      tailoredRemedies.add(pmrCard); // Squeezing extremities directly redirects shaking tremors
      tailoredRemedies.add(const SizedBox(height: 16));
    }

    if (hasCognitive) {
      tailoredRemedies.add(_buildSectionBadge('TARGETS DISSOCIATION & RACING THOUGHTS'));
      tailoredRemedies.add(const SizedBox(height: 8));
      tailoredRemedies.add(sensoryShockCard); // TIPP shock grounds depersonalization instantly
      tailoredRemedies.add(grounding54321Card);
      tailoredRemedies.add(comfortingTruthsCard);
      tailoredRemedies.add(const SizedBox(height: 16));
    }

    if (tailoredRemedies.isEmpty) {
      tailoredRemedies.addAll([
        slowBreathCard,
        grounding54321Card,
      ]);
    } else {
      // Remove trailing Spacer
      tailoredRemedies.removeLast();
    }

    return tailoredRemedies;
  }

  Widget _buildSectionBadge(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: SolaColors.sageAccent.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: SolaColors.sagePrimary,
        ),
      ),
    );
  }
}
