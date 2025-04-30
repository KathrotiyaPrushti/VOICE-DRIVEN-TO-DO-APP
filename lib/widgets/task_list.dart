import 'package:flutter/material.dart';
import 'package:project_exam/models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Future<void> Function(String) onTaskComplete;
  final Future<void> Function(String) onTaskDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskComplete,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => onTaskDelete(task.id),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onTaskComplete(task.id),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                Icons.drag_handle,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        );
      },
    );
  }
} 