import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class SafeCircleScreen extends StatelessWidget {
  final SolaAppState appState;

  const SafeCircleScreen({super.key, required this.appState});

  void _simulateTextCrisis(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Messages: Text HOME to 741741 for immediate support.'),
        backgroundColor: SolaColors.coralSoft,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _simulatePhoneCall(BuildContext context, String name, String relation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $name ($relation)... Calling your anchor.'),
        backgroundColor: SolaColors.sagePrimary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pulse Icon & Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFBECE9),
                  ),
                  child: const Icon(Icons.favorite, color: SolaColors.coralSoft, size: 28),
                ),
                const SizedBox(height: 14),
                const Text(
                  "You're not alone",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Reach out to someone you trust. They want to help you through this.",
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

          // Professional Support
          const Text(
            'PROFESSIONAL SUPPORT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: SolaColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Crisis Text Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F0),
              border: Border.all(color: const Color(0xFFF9DDD8)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.support_agent, color: SolaColors.coralSoft, size: 22),
                ),
                const SizedBox(width: 14),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crisis Text Line',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SolaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Available 24/7 • Confidential',
                        style: TextStyle(
                          fontSize: 12,
                          color: SolaColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Text Button
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SolaColors.coralSoft,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => _simulateTextCrisis(context),
                    child: const Text('Text', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Trusted Friends Section
          const Text(
            'TRUSTED FRIENDS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: SolaColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          _buildFriendCard(context, name: 'Sarah Miller', relation: 'Best Friend', initial: 'SM'),
          const SizedBox(height: 12),
          _buildFriendCard(context, name: 'David Chen', relation: 'Brother', initial: 'DC'),
          const SizedBox(height: 12),
          _buildFriendCard(context, name: 'Dr. Aris', relation: 'Therapist', initial: 'DA', isTherapist: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Trusted Friend Row Card
  Widget _buildFriendCard(
    BuildContext context, {
    required String name,
    required String relation,
    required String initial,
    bool isTherapist = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: SolaColors.sageAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x032B332F),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTherapist ? const Color(0xFFFAF2F7) : SolaColors.bgMain,
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isTherapist ? const Color(0xFFB05085) : SolaColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  relation,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: SolaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Call Action Button
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SolaColors.sageAccent,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.phone, color: SolaColors.sagePrimary, size: 18),
              onPressed: () => _simulatePhoneCall(context, name, relation),
            ),
          ),
        ],
      ),
    );
  }
}
