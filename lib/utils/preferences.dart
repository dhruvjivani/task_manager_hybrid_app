class Performance {
  int? id;
  int taskId;
  DateTime date;
  int durationMinutes; // e.g., time spent on task that day
  String notes;

  Performance({
    this.id,
    required this.taskId,
    required this.date,
    required this.durationMinutes,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
    };
  }

  factory Performance.fromMap(Map<String, dynamic> map) {
    return Performance(
      id: map['id'],
      taskId: map['taskId'],
      date: DateTime.parse(map['date']),
      durationMinutes: map['durationMinutes'],
      notes: map['notes'] ?? '',
    );
  }
}
