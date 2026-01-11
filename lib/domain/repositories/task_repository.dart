import '../entities/task.dart';

abstract class TaskRepository {
  /// Obtiene todas las tareas
  Future<List<Task>> getAllTasks();

  /// Obtiene las tareas de una fecha específica
  Future<List<Task>> getTasksByDate(DateTime date);

  /// Obtiene las tareas de una semana
  Future<List<Task>> getTasksByWeek(DateTime startDate);

  /// Obtiene una tarea por su ID
  Future<Task?> getTaskById(String id);

  /// Crea una nueva tarea
  Future<void> createTask(Task task);

  /// Actualiza una tarea existente
  Future<void> updateTask(Task task);

  /// Elimina una tarea
  Future<void> deleteTask(String id);

  /// Marca una tarea como completada o no completada
  Future<void> toggleTaskCompletion(String id);
}
