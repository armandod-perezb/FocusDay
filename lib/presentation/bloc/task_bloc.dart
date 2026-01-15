import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks_by_date.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/toggle_task_completion.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  Future<void> _onLoadAllTasks(
    LoadAllTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasks();
      emit(TaskLoaded(tasks: tasks, currentDate: DateTime.now()));
    } catch (e) {
      emit(TaskError('Error al cargar todas las tareas: $e'));
    }
  }
  final GetTasksByDate getTasksByDate;
  final GetAllTasks getAllTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTaskCompletion toggleTaskCompletion;

  TaskBloc({
    required this.getTasksByDate,
    required this.getAllTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskCompletion,
  }) : super(TaskInitial()) {
    on<LoadTasksByDate>(_onLoadTasksByDate);
    on<LoadAllTasksEvent>(_onLoadAllTasks);

    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
  }

  Future<void> _onLoadTasksByDate(
    LoadTasksByDate event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByDate(event.date);
      emit(TaskLoaded(tasks: tasks, currentDate: event.date));
    } catch (e) {
      emit(TaskError('Error al cargar tareas: $e'));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await createTask(event.task);
      emit(const TaskOperationSuccess('Tarea creada exitosamente'));
      add(LoadTasksByDate(event.task.date));
    } catch (e) {
      emit(TaskError('Error al crear tarea: $e'));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await updateTask(event.task);
      emit(const TaskOperationSuccess('Tarea actualizada exitosamente'));
      add(LoadTasksByDate(event.task.date));
    } catch (e) {
      emit(TaskError('Error al actualizar tarea: $e'));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTask(event.taskId);
      emit(const TaskOperationSuccess('Tarea eliminada exitosamente'));
      
      // Recargar tareas de la fecha actual
      if (state is TaskLoaded) {
        add(LoadTasksByDate((state as TaskLoaded).currentDate));
      }
    } catch (e) {
      emit(TaskError('Error al eliminar tarea: $e'));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await toggleTaskCompletion(event.taskId);
      
      // Recargar tareas de la fecha actual
      if (state is TaskLoaded) {
        add(LoadTasksByDate((state as TaskLoaded).currentDate));
      }
    } catch (e) {
      emit(TaskError('Error al actualizar estado de tarea: $e'));
    }
  }
}
