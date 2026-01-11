import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    return await localDataSource.getTasksByDate(date);
  }

  @override
  Future<List<Task>> getTasksByWeek(DateTime startDate) async {
    final tasks = await localDataSource.getAllTasks();
    final endDate = startDate.add(const Duration(days: 7));

    return tasks.where((task) {
      return task.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          task.date.isBefore(endDate);
    }).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return await localDataSource.getTaskById(id);
  }

  @override
  Future<void> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.insertTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    await localDataSource.toggleTaskCompletion(id);
  }
}
