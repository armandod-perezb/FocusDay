import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({
    super.key,
    required this.task,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityLabel() {
    switch (task.priority) {
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.low:
        return 'Baja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task.id));
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: task.description != null
            ? Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPriorityLabel(),
                style: TextStyle(
                  color: _getPriorityColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
