import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/breathing_circle.dart';
import '../state/app_state.dart';

class GroundingScreen extends StatefulWidget {
  final SolaAppState appState;

  const GroundingScreen({super.key, required this.appState});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  // Read activeStep dynamically from the global appState
  int get _activeStep => widget.appState.groundingActiveStep;
  
  // Input Controllers for each step
  final List<TextEditingController> _controllers5 = List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _controllers4 = List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _controllers3 = List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _controllers2 = List.generate(2, (_) => TextEditingController());
  final List<TextEditingController> _controllers1 = List.generate(1, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Register listener to react to global navigation resets
    widget.appState.addListener(_onAppStateChanged);
    _clearAllControllers();
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onAppStateChanged);
    for (var c in _controllers5) { c.dispose(); }
    for (var c in _controllers4) { c.dispose(); }
    for (var c in _controllers3) { c.dispose(); }
    for (var c in _controllers2) { c.dispose(); }
    for (var c in _controllers1) { c.dispose(); }
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) {
      setState(() {
        // If state was reset to default (e.g., returned to Home), clear all inputs!
        if (widget.appState.groundingActiveStep == 5) {
          _clearAllControllers();
        }
      });
    }
  }

  void _clearAllControllers() {
    for (var c in _controllers5) { c.clear(); }
    for (var c in _controllers4) { c.clear(); }
    for (var c in _controllers3) { c.clear(); }
    for (var c in _controllers2) { c.clear(); }
    for (var c in _controllers1) { c.clear(); }
  }

  void _advanceStep(int currentStep) {
    widget.appState.setGroundingActiveStep(currentStep - 1);
    
    // If all steps are completed (activeStep is 0), automatically navigate
    if (_activeStep == 0) {
      Future.delayed(const Duration(milliseconds: 600), () {
        widget.appState.navigateTo('reflection');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isAllCompleted = _activeStep == 0;
    
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
                  // Back
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: SolaColors.textSecondary),
                    onPressed: () => widget.appState.navigateTo('symptoms'),
                  ),
                  // Title and Stepper
                  Column(
                    children: [
                      const Text(
                        'Grounding Flow',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStepDot(isActive: false),
                          const SizedBox(width: 4),
                          _buildStepDot(isActive: true),
                          const SizedBox(width: 4),
                          _buildStepDot(isActive: false),
                        ],
                      ),
                    ],
                  ),
                  // Safe Home Escape Hatch
                  IconButton(
                    icon: const Icon(Icons.home_outlined, color: SolaColors.textSecondary),
                    onPressed: () => widget.appState.navigateTo('home'),
                  ),

                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Small Breathing Banner
                    const AnimatedBreathingCircle(isImmersive: false),
                    const SizedBox(height: 20),

                    // Header Info
                    const Text(
                      '5-4-3-2-1 Method',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Let's anchor ourselves in the present moment.",
                      style: TextStyle(
                        fontSize: 14,
                        color: SolaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive Checklist
                    Column(
                      children: [
                        // 5 Things: See (Active initially)
                        _buildChecklistItem(
                          stepNum: 5,
                          label: '5 THINGS',
                          desc: 'You can see around you',
                          icon: Icons.visibility_outlined,
                          drawerInstruction: 'Look around. Slow down. List 5 distinct things you can see in your immediate surroundings.',
                          controllers: _controllers5,
                          hints: ['Something green...', 'Something wooden...', 'Something metallic...', 'Something bright...', 'Something nearby...'],
                        ),

                        const SizedBox(height: 12),

                        // 4 Things: Touch (Active initially)
                        _buildChecklistItem(
                          stepNum: 4,
                          label: '4 THINGS',
                          desc: 'You can touch or feel',
                          icon: Icons.back_hand_outlined,
                          drawerInstruction: 'Focus on textures or temperatures: a cool desk, a soft shirt.',
                          controllers: _controllers4,
                          hints: ['Something cool...', 'Something soft...', 'Something solid...', 'Something textured...'],
                        ),
                        const SizedBox(height: 12),

                        // 3 Things: Hear
                        _buildChecklistItem(
                          stepNum: 3,
                          label: '3 THINGS',
                          desc: 'You can hear right now',
                          icon: Icons.volume_up_outlined,
                          drawerInstruction: 'Close your eyes for a second. What background sounds stand out?',
                          controllers: _controllers3,
                          hints: ['A distant car...', 'The hum of the fan...', 'My own breathing...'],
                        ),
                        const SizedBox(height: 12),

                        // 2 Things: Smell
                        _buildChecklistItem(
                          stepNum: 2,
                          label: '2 THINGS',
                          desc: 'You can smell',
                          icon: Icons.air,
                          drawerInstruction: 'Breathe in deeply. Can you sense a scent of wood, tea, or rain?',
                          controllers: _controllers2,
                          hints: ['A hint of coffee...', 'Fresh laundry...'],
                        ),
                        const SizedBox(height: 12),

                        // 1 Thing: Taste
                        _buildChecklistItem(
                          stepNum: 1,
                          label: '1 THING',
                          desc: 'You can taste',
                          icon: Icons.restaurant_menu_outlined,
                          drawerInstruction: 'What taste lingers on your tongue? Or focus on the feeling of swallowing.',
                          controllers: _controllers1,
                          hints: ['A trace of mint...'],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('I feel calmer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SolaColors.sagePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isAllCompleted ? 4 : 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => widget.appState.navigateTo('reflection'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => widget.appState.setTab(1), // Redirects to the dedicated Relief tab
                    child: const Text(
                      'Try a different exercise',
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
  }

  // Stepper Dot
  Widget _buildStepDot({required bool isActive}) {
    return Container(
      width: isActive ? 14 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? SolaColors.sagePrimary : SolaColors.sagePrimary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // Checklist Item Widget
  Widget _buildChecklistItem({
    required int stepNum,
    required String label,
    required String desc,
    required IconData icon,
    String? drawerInstruction,
    List<TextEditingController>? controllers,
    List<String>? hints,
  }) {
    final bool isCompleted = stepNum > _activeStep;
    final bool isActive = stepNum == _activeStep;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? SolaColors.bgCardAlt : SolaColors.bgCard,
        border: Border.all(
          color: isActive ? SolaColors.sagePrimary : SolaColors.sageAccent.withOpacity(0.5),
          width: isActive ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive 
          ? [BoxShadow(color: SolaColors.sagePrimary.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))]
          : const [BoxShadow(color: Color(0x032B332F), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row (Always Visible)
          Row(
            children: [
              // Circle Icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isActive ? SolaColors.sageAccent : SolaColors.bgMain,
                ),
                child: Icon(
                  icon,
                  color: isCompleted || isActive ? SolaColors.sagePrimary : SolaColors.textSecondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isCompleted ? SolaColors.textMuted : SolaColors.textPrimary,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Checkmark
              Opacity(
                opacity: isCompleted ? 1.0 : 0.15,
                child: Icon(
                  Icons.check_circle,
                  color: isCompleted ? SolaColors.sagePrimary : SolaColors.textMuted,
                  size: 22,
                ),
              ),
            ],
          ),
          
          // Drawer (Visible only when active)
          if (isActive && drawerInstruction != null && controllers != null && hints != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0x18768A7E), style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(top: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      drawerInstruction,
                      style: const TextStyle(
                        fontSize: 12,
                        color: SolaColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Generated text inputs
                    ...List.generate(controllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: controllers[index],
                            decoration: InputDecoration(
                              hintText: hints[index],
                              hintStyle: const TextStyle(fontSize: 13, color: SolaColors.textMuted),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              filled: true,
                              fillColor: SolaColors.bgMain,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: SolaColors.sagePrimary, width: 1),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13, color: SolaColors.textPrimary),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SolaColors.sagePrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _advanceStep(stepNum),
                        child: const Text(
                          "I've found them",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
