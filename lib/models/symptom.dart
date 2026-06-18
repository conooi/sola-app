enum SymptomCategory { physical, emotional }

class Symptom {
  final String id;
  final String displayName;
  final SymptomCategory category;

  const Symptom({
    required this.id,
    required this.displayName,
    required this.category,
  });
}

// Added 'sym_numbness' to the physical symptoms
const List<Symptom> kSymptomsList = [
  Symptom(id: 'sym_heart_rapid', displayName: 'Racing heart', category: SymptomCategory.physical),
  Symptom(id: 'sym_breath_short', displayName: 'Tight chest', category: SymptomCategory.physical),
  Symptom(id: 'sym_breath_short_2', displayName: 'Short of breath', category: SymptomCategory.physical),
  Symptom(id: 'sym_detached', displayName: 'Dizzy', category: SymptomCategory.physical),
  Symptom(id: 'sym_trembling', displayName: 'Shaking', category: SymptomCategory.physical),
  Symptom(id: 'sym_numbness', displayName: 'Numbness / Tingling', category: SymptomCategory.physical),
  Symptom(id: 'sym_nausea', displayName: 'Nausea', category: SymptomCategory.physical),
  
  Symptom(id: 'sym_racing_thoughts', displayName: 'Overwhelmed', category: SymptomCategory.emotional),
  Symptom(id: 'sym_fear_control', displayName: 'Panic', category: SymptomCategory.emotional),
  Symptom(id: 'sym_detached_emotional', displayName: 'Disconnected', category: SymptomCategory.emotional),
  Symptom(id: 'sym_fear_control_2', displayName: 'Trapped', category: SymptomCategory.emotional),
  Symptom(id: 'sym_catastrophizing', displayName: 'Fear', category: SymptomCategory.emotional),
];

// Data Model representing a saved Journal/Reflection Entry
class JournalEntry {
  final String id;
  final DateTime timestamp;
  final String text;
  final String aiResponse;
  final double anxietyLevel;
  final Set<String> feelings;
  final String? trigger;
  final bool isPanicReflection; // true = panic reflection, false = daily mood check-in

  JournalEntry({
    required this.id,
    required this.timestamp,
    required this.text,
    required this.aiResponse,
    required this.anxietyLevel,
    required this.feelings,
    this.trigger,
    required this.isPanicReflection,
  });
}
