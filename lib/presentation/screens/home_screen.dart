import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_list.dart';
import '../widgets/task_form_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    context.read<TaskBloc>().add(LoadTasksByDate(selectedDate));
  }

  void _showTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskFormBottomSheet(
        selectedDate: selectedDate,
      ),
    );
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusDay'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is TaskOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  return TaskList(tasks: state.tasks);
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No hay tareas'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDate(-1),
          ),
          Text(
            _formatDate(selectedDate),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hoy';
    } else if (dateToCheck == today.add(const Duration(days: 1))) {
      return 'Mañana';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return 'Ayer';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
