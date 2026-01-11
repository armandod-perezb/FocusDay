import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusDay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (context) => sl<TaskBloc>(),
        child: const HomeScreen(),
      ),
    );
  }
}
