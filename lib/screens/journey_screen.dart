import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../state/app_state.dart';

class JourneyScreen extends StatelessWidget {
  final SolaAppState appState;

  const JourneyScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Calendar strip at the top
          _buildCalendarStrip(context),
          const SizedBox(height: 24),

          // Weekly Resilience Card
          _buildWeeklyResilienceCard(),
          const SizedBox(height: 24),

          // Common Triggers Section
          _buildTriggersSection(),
          const SizedBox(height: 24),

          // Grounding Success Box
          _buildGroundingSuccessBox(),
          const SizedBox(height: 24),

          // Export Health Report Button
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text('Export Health Report'),
              style: OutlinedButton.styleFrom(
                foregroundColor: SolaColors.textPrimary,
                backgroundColor: SolaColors.bgCard,
                side: const BorderSide(color: Color(0xFFE5EDE9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preparing your health report...'),
                    backgroundColor: SolaColors.sagePrimary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  // Calendar strip at the top
  Widget _buildCalendarStrip(BuildContext context) {
    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final DateTime now = DateTime.now();
    final String monthHeader = "${months[now.month - 1]} ${now.year}";
    
    // Generate 7 days centered around today (today - 3 days to today + 3 days)
    final List<DateTime> days = List.generate(7, (index) {
      return now.subtract(Duration(days: 3 - index));
    });

    return Column(
      children: [
        // Month pagination row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthHeader,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SolaColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20, color: SolaColors.textSecondary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20, color: SolaColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Day pills row
        SizedBox(
          height: 74,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: days.map((day) {
              final bool isToday = day.day == now.day && 
                                   day.month == now.month && 
                                   day.year == now.year;
              
              // Scan app journal history to see if there is an entry on this specific day to show the indicator dot
              final bool hasEntry = appState.journalEntries.any((entry) {
                final date = entry.timestamp;
                return date.day == day.day && 
                       date.month == day.month && 
                       date.year == day.year;
              });

              return _buildCalendarDay(
                dayNum: day.day.toString(),
                hasDot: hasEntry,
                isActive: isToday,
                context: context,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Single Calendar Day builder
  Widget _buildCalendarDay({
    required String dayNum,
    required bool hasDot,
    bool isActive = false,
    BuildContext? context,
  }) {
    return GestureDetector(
      onTap: () {
        if (isActive && context != null) {
          // Open Daily Check-in
          appState.navigateTo('daily_check_in');
        }
      },
      child: Container(
        width: 50,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isActive ? SolaColors.slatePrimary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x032B332F),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNum,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : SolaColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (hasDot)
              Positioned(
                bottom: 12,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : SolaColors.sagePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Weekly Resilience Card
  Widget _buildWeeklyResilienceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x042B332F),
            blurRadius: 15,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: SolaColors.bgMain,
                ),
                child: const Icon(Icons.trending_up, color: SolaColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Resilience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SolaColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '3 episodes handled with grounding',
                      style: TextStyle(
                        fontSize: 12,
                        color: SolaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Custom Bar Chart (Responsive Row of Containers)
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(dayLabel: 'M', heightFraction: 0.45),
                _buildBar(dayLabel: 'T', heightFraction: 0.95),
                _buildBar(dayLabel: 'W', heightFraction: 0.32),
                _buildBar(dayLabel: 'T', heightFraction: 0.78),
                _buildBar(dayLabel: 'F', heightFraction: 0.12),
                _buildBar(dayLabel: 'S', heightFraction: 0.52),
                _buildBar(dayLabel: 'S', heightFraction: 0.35),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Single bar builder
  Widget _buildBar({required String dayLabel, required double heightFraction}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: heightFraction,
              child: Container(
                width: 16,
                decoration: BoxDecoration(
                  color: SolaColors.sageMedium,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          dayLabel,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: SolaColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Common Triggers Card
  Widget _buildTriggersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x042B332F),
            blurRadius: 15,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Common Triggers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SolaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildTriggerProgressRow(label: 'Racing Heart', percentage: 72),
          const SizedBox(height: 16),
          _buildTriggerProgressRow(label: 'Shortness of Breath', percentage: 45),
          const SizedBox(height: 16),
          _buildTriggerProgressRow(label: 'Overwhelmed', percentage: 88),
          const SizedBox(height: 16),
          _buildTriggerProgressRow(label: 'Dizzy', percentage: 20),
        ],
      ),
    );
  }

  // Horizontal Trigger Statistics Row
  Widget _buildTriggerProgressRow({required String label, required int percentage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: SolaColors.textPrimary,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: SolaColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Premium horizontal progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              backgroundColor: SolaColors.sageAccent,
              valueColor: const AlwaysStoppedAnimation<Color>(SolaColors.sageMedium),
            ),
          ),
        ),
      ],
    );
  }

  // Grounding Success Achievement Box
  Widget _buildGroundingSuccessBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5F0), // Soft warm sand/cream color
        border: Border.all(color: const Color(0xFFF0E5DC)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.auto_awesome, color: SolaColors.sagePrimary, size: 18),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grounding Success',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: SolaColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'The 5-4-3-2-1 technique has helped reduce your panic duration by 15% this month.',
                  style: TextStyle(
                    fontSize: 13,
                    color: SolaColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
