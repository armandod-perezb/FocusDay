import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksByDate {
  final TaskRepository repository;

  GetTasksByDate(this.repository);

  Future<List<Task>> call(DateTime date) async {
    return await repository.getTasksByDate(date);
  }
}
