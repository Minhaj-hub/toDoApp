class Task {
  String id;
  String title;
  String? description;
  String priority;
  String dueDate;
  String dueTime;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.dueDate,
     required this.dueTime,
    required this.isCompleted,
  });
}
