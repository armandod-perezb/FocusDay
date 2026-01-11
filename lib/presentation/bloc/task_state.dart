import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final DateTime currentDate;

  const TaskLoaded({
    required this.tasks,
    required this.currentDate,
  });

  @override
  List<Object?> get props => [tasks, currentDate];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
