import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/symptom.dart';
import '../state/app_state.dart';

class JournalScreen extends StatelessWidget {
  final SolaAppState appState;

  const JournalScreen({super.key, required this.appState});

  // Helper to format DateTime to a clean, readable string
  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute < 10 ? '0${dt.minute}' : '${dt.minute}';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final entries = appState.journalEntries;
        
        return Scaffold(
          backgroundColor: SolaColors.bgMain,
          // Floating Action Button to add a new check-in
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              appState.navigateTo('daily_check_in');
            },
            backgroundColor: SolaColors.slatePrimary,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add, size: 28),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Journal History',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: SolaColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Reflections & daily mood logs',
                            style: TextStyle(
                              fontSize: 13,
                              color: SolaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      // Refresh/Search icon
                      IconButton(
                        icon: const Icon(Icons.search, color: SolaColors.textSecondary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Timeline List
                Expanded(
                  child: entries.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          itemCount: entries.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _JournalEntryCard(entry: entries[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Empty State Widget when no journals are present
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: SolaColors.sageAccent,
            ),
            child: const Icon(Icons.book_outlined, size: 36, color: SolaColors.sagePrimary),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your journal is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SolaColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Every reflection and check-in you save will appear here in a beautiful, secure timeline.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: SolaColors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Stateful Card with collapsible AI response
class _JournalEntryCard extends StatefulWidget {
  final JournalEntry entry;

  const _JournalEntryCard({required this.entry});

  @override
  State<_JournalEntryCard> createState() => _JournalEntryCardState();
}

class _JournalEntryCardState extends State<_JournalEntryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final bool isPanic = entry.isPanicReflection;
    final String formattedDate = _JournalScreenState()._formatDateTime(entry.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Category Pill & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPanic ? const Color(0xFFFDECE9) : SolaColors.slateAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPanic ? 'Panic Relief' : 'Daily Check-in',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isPanic ? const Color(0xFFC7503B) : SolaColors.slatePrimary,
                  ),
                ),
              ),
              // Anxiety Level Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: SolaColors.bgMain,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Anxiety: ${entry.anxietyLevel.toInt()}/10',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Date Text
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: SolaColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Journal Notes Text
          Text(
            entry.text,
            style: const TextStyle(
              fontSize: 14,
              color: SolaColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          // Trigger & Feelings Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (entry.trigger != null && entry.trigger != 'unknown')
                _buildChip(
                  label: 'Trigger: ${entry.trigger![0].toUpperCase()}${entry.trigger!.substring(1)}',
                  color: const Color(0xFFF3EFE9),
                  textColor: SolaColors.textPrimary,
                ),
              ...entry.feelings.map((feeling) => _buildChip(
                    label: feeling[0].toUpperCase() + feeling.substring(1),
                    color: SolaColors.sageAccent.withOpacity(0.6),
                    textColor: SolaColors.sagePrimary,
                  )),
            ],
          ),
          
          // Expandable AI Response Block
          if (entry.aiResponse.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: SolaColors.bgCardAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SolaColors.sageAccent.withOpacity(0.4)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // AI Companion Header Row
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 14, color: SolaColors.sagePrimary),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Companion Reflection',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: SolaColors.sagePrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: SolaColors.sagePrimary,
                        ),
                      ],
                    ),
                    // Collapsible Text Drawer
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        height: _isExpanded ? null : 0,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          entry.aiResponse,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: SolaColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Tiny Badge Chip builder
  Widget _buildChip({required String label, required Color color, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

// Temporary subclass to allow access to formatting function
class _JournalScreenState {
  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute < 10 ? '0${dt.minute}' : '${dt.minute}';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:$minute $period';
  }
}
