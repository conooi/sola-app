import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class DailyCheckInScreen extends StatefulWidget {
  final SolaAppState appState;

  const DailyCheckInScreen({super.key, required this.appState});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Determine descriptive text for anxiety slider levels
  String _getAnxietyLabel(double value) {
    if (value <= 3.0) return 'Low';
    if (value <= 7.0) return 'Medium';
    return 'High';
  }

  void _handleSave(BuildContext context) {
    final notes = _notesController.text.trim();
    widget.appState.saveDailyCheckIn(notes);
    
    // SnackBar Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily reflection saved! Star added to your Constellation.'),
        backgroundColor: SolaColors.sagePrimary,
      ),
    );

    // Redirect to main journal history page
    widget.appState.navigateTo('journal');

  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        final double anxietyLevel = widget.appState.dailyAnxietyLevel;
        
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
                      // Back & Home Escape Hatch
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: SolaColors.textSecondary),
                            onPressed: () => widget.appState.navigateTo('user'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.home_outlined, color: SolaColors.textSecondary),
                            onPressed: () => widget.appState.navigateTo('home'),
                          ),
                        ],
                      ),

                      // Title
                      const Column(
                        children: [
                          Text(
                            'Reflect',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: SolaColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Journal your thoughts',
                            style: TextStyle(
                              fontSize: 11,
                              color: SolaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      // Checkmark Save button
                      IconButton(
                        icon: const Icon(Icons.check, color: SolaColors.sagePrimary),
                        onPressed: () => _handleSave(context),
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
                        // Mood Selector
                        const Text(
                          'How are you feeling right now?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildMoodPill('anxious', 'Anxious'),
                            _buildMoodPill('overwhelmed', 'Overwhelmed'),
                            _buildMoodPill('restless', 'Restless'),
                            _buildMoodPill('tired', 'Tired'),
                            _buildMoodPill('calm', 'Calm'),
                            _buildMoodPill('scared', 'Scared'),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Anxiety Intensity Slider Card
                        const Text(
                          'Anxiety Intensity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x032B332F),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: SolaColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    _getAnxietyLabel(anxietyLevel),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: SolaColors.sagePrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Slider
                              Slider(
                                value: anxietyLevel,
                                min: 1.0,
                                max: 10.0,
                                divisions: 9,
                                activeColor: SolaColors.slatePrimary,
                                inactiveColor: const Color(0xFFFAF2F0),
                                onChanged: (val) => widget.appState.updateDailyAnxietyLevel(val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // What triggered this feeling Grid
                        const Text(
                          'What triggered this feeling?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Builder(
                          builder: (context) {
                            final bool isPhysicalSelected = widget.appState.selectedDailyTrigger == 'physical';
                            final bool isExternalSelected = widget.appState.selectedDailyTrigger == 'external';
                            
                            return Row(
                              children: [
                                // Trigger Card 1: Physical
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => widget.appState.selectDailyTrigger('physical'),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: 160,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isPhysicalSelected ? SolaColors.sageAccent : Colors.white,
                                        border: Border.all(
                                          color: isPhysicalSelected 
                                              ? SolaColors.sagePrimary 
                                              : SolaColors.sageAccent.withOpacity(0.6),
                                          width: isPhysicalSelected ? 1.5 : 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x032B332F),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isPhysicalSelected ? SolaColors.sagePrimary : SolaColors.bgMain,
                                            ),
                                            child: Icon(
                                              Icons.directions_run, 
                                              color: isPhysicalSelected ? Colors.white : SolaColors.sagePrimary, 
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Physical Factors',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Sleep, caffeine, activity',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10, color: SolaColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Trigger Card 2: External
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => widget.appState.selectDailyTrigger('external'),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: 160,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isExternalSelected ? SolaColors.sageAccent : Colors.white,
                                        border: Border.all(
                                          color: isExternalSelected 
                                              ? SolaColors.sagePrimary 
                                              : SolaColors.sageAccent.withOpacity(0.6),
                                          width: isExternalSelected ? 1.5 : 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x032B332F),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isExternalSelected ? SolaColors.sagePrimary : SolaColors.bgMain,
                                            ),
                                            child: Icon(
                                              Icons.language, 
                                              color: isExternalSelected ? Colors.white : SolaColors.sagePrimary, 
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'External Factors',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Social, environment, work',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10, color: SolaColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        const SizedBox(height: 28),

                        // Notes & Reflections card
                        const Text(
                          'Notes & Reflections',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x032B332F),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'JOURNAL ENTRY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: SolaColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _notesController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: 'Describe what\'s on your mind...',
                                  hintStyle: TextStyle(color: SolaColors.textMuted, fontSize: 13.5),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(fontSize: 14, color: SolaColors.textPrimary, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Why Journaling Helps Info Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: SolaColors.bgCardAlt,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5EDE9)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: SolaColors.slatePrimary, size: 18),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Why Journaling Helps: Putting your feelings into words reduces amygdala activity, helping to logically organize and de-escalate anxiety spikes.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: SolaColors.textSecondary,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SolaColors.slatePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _handleSave(context),
                      child: const Text('Save Reflection'),
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

  // Mood selector pill builder
  Widget _buildMoodPill(String id, String label) {
    final bool isSelected = widget.appState.dailyFeelings.contains(id);
    
    return GestureDetector(
      onTap: () => widget.appState.toggleDailyFeeling(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? SolaColors.sagePrimary : Colors.white,
          border: Border.all(
            color: isSelected ? SolaColors.sagePrimary : SolaColors.sageAccent,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
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
