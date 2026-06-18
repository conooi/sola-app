import 'package:flutter/material.dart';
import '../models/symptom.dart';

class SolaAppState extends ChangeNotifier {
  // Navigation State
  String _currentScreen = 'home';
  String get currentScreen => _currentScreen;

  int _currentTab = 0; // 0 = Grounding, 1 = Journey, 2 = Safe Circle, 3 = Journal
  int get currentTab => _currentTab;

  // Symptom Checker State
  final Set<String> _selectedSymptoms = {};
  Set<String> get selectedSymptoms => _selectedSymptoms;

  // Panic Session Reflection State
  String? _selectedTrigger;
  String? get selectedTrigger => _selectedTrigger;

  final Set<String> _selectedFeelings = {};
  Set<String> get selectedFeelings => _selectedFeelings;

  String _journalText = "";
  String get journalText => _journalText;

  String _aiResponse = "";
  String get aiResponse => _aiResponse;

  bool _isAiTyping = false;
  bool get isAiTyping => _isAiTyping;

  bool _isCrisisDetected = false;
  bool get isCrisisDetected => _isCrisisDetected;

  // Daily Check-in / Reflect State
  final Set<String> _dailyFeelings = {};
  Set<String> get dailyFeelings => _dailyFeelings;

  double _dailyAnxietyLevel = 6.0;
  double get dailyAnxietyLevel => _dailyAnxietyLevel;

  String _dailyJournalText = "";
  String get dailyJournalText => _dailyJournalText;

  bool _dailyCheckInCompleted = false;
  bool get dailyCheckInCompleted => _dailyCheckInCompleted;

  String? _selectedDailyTrigger;
  String? get selectedDailyTrigger => _selectedDailyTrigger;

  // Grounding Flow State (Screen 3)
  int _groundingActiveStep = 5; // Default to 5 (making Step 5 fully interactive)
  int get groundingActiveStep => _groundingActiveStep;

  void setGroundingActiveStep(int step) {
    _groundingActiveStep = step;
    notifyListeners();
  }

  // User Settings Switches
  bool _dailyCheckinsEnabled = true;
  bool get dailyCheckinsEnabled => _dailyCheckinsEnabled;

  bool _panicAlertsEnabled = true;
  bool get panicAlertsEnabled => _panicAlertsEnabled;

  String _reminderTime = "9:00 AM";
  String get reminderTime => _reminderTime;

  double _breathingPaceSeconds = 4.0;
  double get breathingPaceSeconds => _breathingPaceSeconds;

  bool _hapticFeedbackEnabled = true;
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;

  // Gamification State
  int _stars = 5; // Start with 5 stars for a richer constellation
  int get stars => _stars;

  // Journal Database (Local-first list simulation)
  final List<JournalEntry> _journalEntries = [
    JournalEntry(
      id: 'mock_1',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      text: "Woke up feeling extremely tight in the chest. Fought racing thoughts about my presentation. Tried to slow down my breathing.",
      aiResponse: "I hear how heavy that presentation pressure felt. It is completely natural that your chest tightened up under that weight. You did beautifully by choosing to slow down your breath. Remember, you don't have to carry the whole day at once. You are safe in this moment.",
      anxietyLevel: 8.0,
      feelings: {'anxious', 'overwhelmed'},
      trigger: 'work',
      isPanicReflection: true,
    ),
    JournalEntry(
      id: 'mock_2',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      text: "Logged a daily check-in. Felt relatively peaceful today, just a bit tired after work. Enjoyed some quiet tea.",
      aiResponse: "Taking a quiet moment for tea is a wonderful way to ground yourself. It is completely okay to feel tired. Acknowledge your body's request to rest, and rest without guilt.",
      anxietyLevel: 3.0,
      feelings: {'calm', 'peaceful'},
      trigger: 'unknown',
      isPanicReflection: false,
    ),
  ];
  List<JournalEntry> get journalEntries => _journalEntries;

  // Navigation Methods
  void navigateTo(String screenName) {
    _currentScreen = screenName;
    
    // Auto-synchronize bottom tab highlights
    if (screenName == 'home') _currentTab = 0;
    if (screenName == 'relief') _currentTab = 1;
    if (screenName == 'journal') _currentTab = 2;
    if (screenName == 'user') _currentTab = 3;

    if (screenName == 'home') {
      // Centralized session clearing: returning to Home resets all panic logs
      _selectedSymptoms.clear();
      _selectedTrigger = null;
      _selectedFeelings.clear();
      _journalText = "";
      _aiResponse = "";
      _isAiTyping = false;
      _isCrisisDetected = false;
      _groundingActiveStep = 5; // Cleanly reset grounding active step to 5!
    }
    notifyListeners();
  }

  void setTab(int index) {
    _currentTab = index;
    if (index == 0) _currentScreen = 'home';
    if (index == 1) _currentScreen = 'relief';
    if (index == 2) _currentScreen = 'journal';
    if (index == 3) _currentScreen = 'user';
    notifyListeners();
  }


  // Symptom Toggles
  void toggleSymptom(String symptomId) {
    if (_selectedSymptoms.contains(symptomId)) {
      _selectedSymptoms.remove(symptomId);
    } else {
      _selectedSymptoms.add(symptomId);
    }
    notifyListeners();
  }

  void clearSymptoms() {
    _selectedSymptoms.clear();
    notifyListeners();
  }

  // Trigger Selection
  void selectTrigger(String triggerId) {
    if (_selectedTrigger == triggerId) {
      _selectedTrigger = null;
    } else {
      _selectedTrigger = triggerId;
    }
    notifyListeners();
  }

  // Feeling Selection
  void toggleFeeling(String feelingId) {
    if (_selectedFeelings.contains(feelingId)) {
      _selectedFeelings.remove(feelingId);
    } else {
      _selectedFeelings.add(feelingId);
    }
    notifyListeners();
  }

  // Settings Toggles
  void toggleDailyCheckins(bool value) {
    _dailyCheckinsEnabled = value;
    notifyListeners();
  }

  void togglePanicAlerts(bool value) {
    _panicAlertsEnabled = value;
    notifyListeners();
  }

  void toggleHapticFeedback(bool value) {
    _hapticFeedbackEnabled = value;
    notifyListeners();
  }

  void updateBreathingPace(double seconds) {
    _breathingPaceSeconds = seconds;
    notifyListeners();
  }

  // Daily Check-in Methods
  void toggleDailyFeeling(String feelingId) {
    if (_dailyFeelings.contains(feelingId)) {
      _dailyFeelings.remove(feelingId);
    } else {
      _dailyFeelings.add(feelingId);
    }
    notifyListeners();
  }

  void updateDailyAnxietyLevel(double level) {
    _dailyAnxietyLevel = level;
    notifyListeners();
  }

  void selectDailyTrigger(String triggerId) {
    if (_selectedDailyTrigger == triggerId) {
      _selectedDailyTrigger = null;
    } else {
      _selectedDailyTrigger = triggerId;
    }
    notifyListeners();
  }

  // Save Daily Check-in to History
  void saveDailyCheckIn(String notes) {
    _dailyJournalText = notes;
    _dailyCheckInCompleted = true;
    _stars++;

    // Insert new daily entry to the list
    _journalEntries.insert(
      0,
      JournalEntry(
        id: 'daily_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        text: notes.isEmpty ? "Logged a daily check-in." : notes,
        aiResponse: notes.isEmpty 
            ? "Thank you for checking in. Acknowledging your emotional state is a powerful first step."
            : "I hear you. Putting your thoughts down is a beautiful way to release them. Rest in this still, quiet space.",
        anxietyLevel: _dailyAnxietyLevel,
        feelings: Set.from(_dailyFeelings),
        trigger: _selectedDailyTrigger ?? 'unknown',
        isPanicReflection: false,
      ),
    );

    // Reset daily check-in state variables cleanly for the next session
    _dailyFeelings.clear();
    _dailyAnxietyLevel = 6.0;
    _dailyJournalText = "";
    _selectedDailyTrigger = null;
    _dailyCheckInCompleted = false;

    notifyListeners();
  }

  void resetDailyCheckIn() {
    _dailyFeelings.clear();
    _dailyAnxietyLevel = 6.0;
    _dailyJournalText = "";
    _selectedDailyTrigger = null;
    _dailyCheckInCompleted = false;
    notifyListeners();
  }

  // Crisis Keywords
  static const List<String> _crisisKeywords = [
    'end it all', 'kill myself', 'suicide', 'die', 'want to die', 
    'hurt myself', 'no point in living', 'end my life', 'cutting'
  ];

  // Save Panic Journal to History and Generate AI Response
  void saveJournalEntry(String text) {
    _journalText = text;
    _isAiTyping = true;
    _aiResponse = "";
    _isCrisisDetected = false;
    notifyListeners();

    final lowerText = text.toLowerCase();
    bool crisisFound = false;
    for (final keyword in _crisisKeywords) {
      if (lowerText.contains(keyword)) {
        crisisFound = true;
        break;
      }
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      _isAiTyping = false;
      
      if (crisisFound) {
        _isCrisisDetected = true;
        _aiResponse = "I hear how incredibly painful and overwhelming things are right now. Because I want you to be safe and supported by real people who can help, please reach out to someone who can hold space for you. You can connect with a supportive voice at the Crisis Text Line by texting HOME to 741741, or calling/texting 988. You do not have to carry this alone.";
      } else {
        _stars++;
        
        final hasWork = _selectedTrigger == 'work';
        final hasSocial = _selectedTrigger == 'social';
        final hasHealth = _selectedTrigger == 'health';
        
        final isExhausted = _selectedFeelings.contains('exhausted');
        final isShaky = _selectedFeelings.contains('shaky');

        if (hasWork) {
          _aiResponse = "I hear how much pressure you've been carrying with work. It makes complete sense that you feel ${isExhausted ? "exhausted" : "overwhelmed"} right now. You don't have to carry the whole project today. If it feels okay, try releasing your shoulders away from your ears and letting out a slow sigh. You are safe in this moment.";
        } else if (hasSocial) {
          _aiResponse = "Social settings can demand so much energy, and it's completely valid that you needed to step away. I hear you. If you feel up to it, place both feet flat on the floor and feel the solid ground holding you up. You are allowed to take up space and go at your own pace.";
        } else if (hasHealth) {
          _aiResponse = "Health worries can feel extremely frightening and real. Your body was trying to protect you, even if it felt scary. Your heart rate is slowing down now, and you are safe. Try touching something warm nearby, like a cup, and focus on that simple warmth. I am right here with you.";
        } else {
          _aiResponse = "Thank you for putting your thoughts down. It is completely okay to feel ${isShaky ? "shaky" : "uncertain"} after a panic spike. You have survived 100% of these waves, and this one is dissolving too. Take a slow, gentle breath, and let your body settle. You are doing wonderfully.";
        }
      }

      // Add to our journal history!
      _journalEntries.insert(
        0,
        JournalEntry(
          id: 'panic_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          text: text.isEmpty ? "Completed a grounding session." : text,
          aiResponse: _aiResponse,
          anxietyLevel: _isCrisisDetected ? 10.0 : 8.0, // High anxiety represented in panic
          feelings: Set.from(_selectedFeelings),
          trigger: _selectedTrigger,
          isPanicReflection: true,
        ),
      );

      notifyListeners();
    });
  }

  void resetReflection() {
    _journalText = "";
    _aiResponse = "";
    _isAiTyping = false;
    _isCrisisDetected = false;
    _selectedTrigger = null;
    _selectedFeelings.clear();
    _selectedSymptoms.clear();      // Clear old checked symptoms so symptom selector starts fresh!
    _groundingActiveStep = 5;       // Reset grounding flow checklist back to step 5!
    notifyListeners();
  }
}
