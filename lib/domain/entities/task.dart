import 'package:equatable/equatable.dart';

enum TaskPriority { high, medium, low }

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.priority,
    this.isCompleted = false,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        priority,
        isCompleted,
        reminderTime,
        createdAt,
        updatedAt,
      ];
}
