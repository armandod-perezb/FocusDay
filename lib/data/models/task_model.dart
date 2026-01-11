import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required super.priority,
    super.isCompleted,
    super.reminderTime,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      priority: TaskPriority.values[json['priority'] as int],
      isCompleted: json['is_completed'] == 1,
      reminderTime: json['reminder_time'] != null
          ? DateTime.parse(json['reminder_time'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'priority': priority.index,
      'is_completed': isCompleted ? 1 : 0,
      'reminder_time': reminderTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      priority: task.priority,
      isCompleted: task.isCompleted,
      reminderTime: task.reminderTime,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}
