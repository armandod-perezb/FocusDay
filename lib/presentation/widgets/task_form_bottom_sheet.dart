import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskFormBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final Task? task;

  const TaskFormBottomSheet({
    super.key,
    required this.selectedDate,
    this.task,
  });

  @override
  State<TaskFormBottomSheet> createState() => _TaskFormBottomSheetState();
}

class _TaskFormBottomSheetState extends State<TaskFormBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es requerido')),
      );
      return;
    }

    final now = DateTime.now();
    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      date: widget.selectedDate,
      priority: _selectedPriority,
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.task == null) {
      context.read<TaskBloc>().add(CreateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.task == null ? 'Nueva Tarea' : 'Editar Tarea',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskPriority>(
            value: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Prioridad',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: TaskPriority.high,
                child: Text('Alta'),
              ),
              DropdownMenuItem(
                value: TaskPriority.medium,
                child: Text('Media'),
              ),
              DropdownMenuItem(
                value: TaskPriority.low,
                child: Text('Baja'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPriority = value;
                });
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveTask,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(widget.task == null ? 'Crear Tarea' : 'Guardar'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
