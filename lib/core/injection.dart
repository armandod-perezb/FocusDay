import 'package:get_it/get_it.dart';

import '../data/datasources/task_local_datasource.dart';
import '../data/repositories/task_repository_impl.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/usecases/create_task.dart';
import '../domain/usecases/delete_task.dart';
import '../domain/usecases/get_all_tasks.dart'; // ✅ AÑADIDO
import '../domain/usecases/get_tasks_by_date.dart';
import '../domain/usecases/toggle_task_completion.dart';
import '../domain/usecases/update_task.dart';
import '../presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
        () => TaskLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasksByDate(sl()));
  sl.registerLazySingleton(() => GetAllTasks(sl())); // ✅ AÑADIDO
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompletion(sl()));

  // BLoC
  sl.registerFactory(
        () => TaskBloc(
      getTasksByDate: sl(),
      getAllTasks: sl(), // ✅ ya existe
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      toggleTaskCompletion: sl(),
    ),
  );
}
