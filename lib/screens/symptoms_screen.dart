import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/symptom.dart';
import '../state/app_state.dart';

class SymptomsScreen extends StatelessWidget {
  final SolaAppState appState;

  const SymptomsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final selectedCount = appState.selectedSymptoms.length;
        
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
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: SolaColors.textSecondary),
                        onPressed: () => appState.navigateTo('home'),
                      ),
                      // Stepper dots
                      Row(
                        children: [
                          _buildStepDot(isActive: true),
                          const SizedBox(width: 6),
                          _buildStepDot(isActive: false),
                          const SizedBox(width: 6),
                          _buildStepDot(isActive: false),
                        ],
                      ),
                      // Close button
                      IconButton(
                        icon: const Icon(Icons.close, color: SolaColors.textSecondary),
                        onPressed: () => appState.navigateTo('home'),
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Header
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'Notice your body',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: SolaColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Gently tap what you're feeling right now.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: SolaColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Physical Category
                        _buildSymptomSection(
                          title: 'PHYSICAL',
                          category: SymptomCategory.physical,
                        ),
                        const SizedBox(height: 24),

                        // Emotional Category
                        _buildSymptomSection(
                          title: 'EMOTIONAL',
                          category: SymptomCategory.emotional,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA Panel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SolaColors.slatePrimary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: SolaColors.sageLight.withOpacity(0.6),
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: selectedCount > 0 ? 4 : 0,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: selectedCount > 0
                              ? () {
                                  // Dynamic diagnostic routing based on checked symptoms
                                  final selected = appState.selectedSymptoms;
                                  
                                  final hasRespiratory = selected.contains('sym_heart_rapid') || 
                                                         selected.contains('sym_breath_short') || 
                                                         selected.contains('sym_breath_short_2');
                                                         
                                  final hasSomatic = selected.contains('sym_trembling') || 
                                                     selected.contains('sym_numbness') || 
                                                     selected.contains('sym_nausea');

                                  if (hasRespiratory) {
                                    // Profile: Racing Heart / dyspnea -> Physiological Sigh
                                    appState.navigateTo('sigh_breather');
                                  } else if (hasSomatic) {
                                    // Profile: Shaking / Tremors -> Somatic Shaking
                                    appState.navigateTo('shaking_exercise');
                                  } else {
                                    // Profile: Racing Thoughts / Dissociation -> 5-4-3-2-1 Grounding
                                    appState.navigateTo('grounding');
                                  }
                                }
                              : null,

                          child: const Text('Begin Grounding Flow'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => appState.navigateTo('reassurance'),
                        child: const Text(
                          "I'm just browsing for now",
                          style: TextStyle(
                            color: SolaColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Stepper dot helper
  Widget _buildStepDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 24,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? SolaColors.sagePrimary : SolaColors.sagePrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // Symptom Section Pill Grid Generator
  Widget _buildSymptomSection({required String title, required SymptomCategory category}) {
    final list = kSymptomsList.where((s) => s.category == category).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: SolaColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: list.map((symptom) => _buildSymptomPill(symptom)).toList(),
        ),
      ],
    );
  }

  // Individual Pill Button
  Widget _buildSymptomPill(Symptom symptom) {
    final bool isSelected = appState.selectedSymptoms.contains(symptom.id);
    
    return GestureDetector(
      onTap: () => appState.toggleSymptom(symptom.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? SolaColors.slatePrimary : SolaColors.bgCard,
          border: Border.all(
            color: isSelected ? SolaColors.slatePrimary : SolaColors.sageAccent.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x032B332F),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Text(
          symptom.displayName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : SolaColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
