class Task {
  final int? id;
  final String name;
  final DateTime dueDate;
  final String priority;

  Task({this.id, required this.name, required this.dueDate, required this.priority});

  Task copyWith({int? id, String? name, DateTime? dueDate, String? priority}) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
    );
  }
}
