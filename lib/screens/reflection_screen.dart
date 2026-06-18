import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';
import '../state/app_state.dart';


class ReflectionScreen extends StatefulWidget {
  final SolaAppState appState;

  const ReflectionScreen({super.key, required this.appState});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final TextEditingController _journalController = TextEditingController();
  bool _hasSaved = false;

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  // Trigger the premium floating star overlay
  void _showFloatingStar(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => const FloatingStarAnimation(),
    );

    overlayState.insert(overlayEntry);

    // Automatically remove overlay after animation ends
    Future.delayed(const Duration(milliseconds: 2200), () {
      overlayEntry.remove();
    });
  }

  void _handleSave(BuildContext context) {
    if (_hasSaved) return;
    
    final noteText = _journalController.text.trim();
    widget.appState.saveJournalEntry(noteText);
    
    setState(() {
      _hasSaved = true;
    });

    // Trigger the premium star reward
    _showFloatingStar(context);

    // Schedule redirection to main journal history page after AI finishes typing and user reads it
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (mounted) {
        widget.appState.navigateTo('journal');
        widget.appState.resetReflection();
        setState(() {
          _hasSaved = false;
          _journalController.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        final bool showAiResponse = widget.appState.isAiTyping || widget.appState.aiResponse.isNotEmpty;
        
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
                        onPressed: () => widget.appState.navigateTo('grounding'),
                      ),
                      const Text(
                        'Reflection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                        ),
                      ),
                      // Safe Home Escape Hatch
                      IconButton(
                        icon: const Icon(Icons.home_outlined, color: SolaColors.textSecondary),
                        onPressed: () {
                          widget.appState.navigateTo('home');
                          widget.appState.resetReflection();
                        },
                      ),

                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hero Section
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SolaColors.pinkAccent,
                                ),
                                child: const Icon(Icons.auto_awesome, color: SolaColors.sagePrimary, size: 28),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'The storm has passed',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: SolaColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  "You're safe now. Let's take a moment to ground what just happened.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: SolaColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Triggers Grid
                        const Text(
                          'What triggered this episode?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            _buildTriggerCard(id: 'work', title: 'Work Stress', icon: Icons.work_outline),
                            _buildTriggerCard(id: 'social', title: 'Social Setting', icon: Icons.people_outline),
                            _buildTriggerCard(id: 'health', title: 'Health Worry', icon: Icons.favorite_border),
                            _buildTriggerCard(id: 'unknown', title: 'Unknown', icon: Icons.help_outline),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Feelings grid
                        const Text(
                          'How do you feel now?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildFeelingPill('exhausted', 'Exhausted'),
                            _buildFeelingPill('relieved', 'Relieved'),
                            _buildFeelingPill('shaky', 'Shaky'),
                            _buildFeelingPill('sad', 'Sad'),
                            _buildFeelingPill('numb', 'Numb'),
                            _buildFeelingPill('peaceful', 'Peaceful'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Note text box
                        const Text(
                          'Notes for your future self',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: SolaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: SolaColors.sageAccent),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x032B332F),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _journalController,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 14, color: SolaColors.textPrimary, height: 1.5),
                            decoration: const InputDecoration(
                              hintText: 'Write down anything that helped you or anything you want to release...',
                              hintStyle: TextStyle(color: SolaColors.textMuted, fontSize: 13.5),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Dynamic AI Grounding companion bubble
                        if (showAiResponse) ...[
                          _buildAiResponseBubble(),
                          const SizedBox(height: 24),
                        ]
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _hasSaved ? SolaColors.slateLight : SolaColors.sagePrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: _hasSaved ? 0 : 3,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _hasSaved ? null : () => _handleSave(context),
                          child: Text(_hasSaved ? 'Journal Saved' : 'Save to Journal'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          widget.appState.navigateTo('home');
                          widget.appState.resetReflection();
                        },
                        child: const Text(
                          "I'm not ready to talk yet",
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

  // Reusable Trigger Card builder
  Widget _buildTriggerCard({required String id, required String title, required IconData icon}) {
    final bool isSelected = widget.appState.selectedTrigger == id;
    
    return GestureDetector(
      onTap: () => widget.appState.selectTrigger(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? SolaColors.sageAccent : Colors.white,
          border: Border.all(
            color: isSelected ? SolaColors.sagePrimary : SolaColors.sageAccent.withOpacity(0.6),
            width: isSelected ? 1.5 : 1.0,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? SolaColors.sagePrimary : SolaColors.bgMain,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : SolaColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SolaColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Feeling Pill builder
  Widget _buildFeelingPill(String id, String label) {
    final bool isSelected = widget.appState.selectedFeelings.contains(id);
    
    return GestureDetector(
      onTap: () => widget.appState.toggleFeeling(id),
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

  // Simulated AI Writing Companion Bubble Card
  Widget _buildAiResponseBubble() {
    final bool isTyping = widget.appState.isAiTyping;
    final String text = widget.appState.aiResponse;
    final bool isCrisis = widget.appState.isCrisisDetected;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaColors.sageAccent,
        border: Border.all(color: SolaColors.sageAccent),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.chat_bubble_outline, size: 14, color: SolaColors.sagePrimary),
              ),
              const SizedBox(width: 8),
              const Text(
                'WRITING COMPANION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: SolaColors.sagePrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Content or Typing Indicator
          if (isTyping) ...[
            const Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(SolaColors.sagePrimary),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Typing a supportive reflection...',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: SolaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: isCrisis ? SolaColors.coralSoft : SolaColors.textPrimary,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================================================
// Floating Star Overlay (Premium Reward Micro-interaction)
// ==========================================================================
class FloatingStarAnimation extends StatefulWidget {
  const FloatingStarAnimation({super.key});

  @override
  State<FloatingStarAnimation> createState() => _FloatingStarAnimationState();
}

class _FloatingStarAnimationState extends State<FloatingStarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _yTranslationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Custom cubic-bezier matching the CSS float
    final CurvedAnimation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.2, end: 1.4).chain(CurveTween(curve: Curves.easeOutBack)), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(curve);

    _yTranslationAnimation = Tween<double>(begin: 0.0, end: -350.0).animate(curve);
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(curve); // Rotates 720 degrees (2 full turns)

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 35),
    ]).animate(curve);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height / 2 + _yTranslationAnimation.value,
          left: MediaQuery.of(context).size.width / 2 - 25,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * math.pi,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: const Icon(
                  Icons.star,
                  color: SolaColors.goldAccent,
                  size: 50,
                  shadows: [
                    Shadow(
                      color: Color(0x3DF4D068),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
