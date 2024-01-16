import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker/domain/entities/task_entity.dart';
import 'package:task_tracker/presentation/bloc/task_bloc.dart';

class TaskDetailsPage extends StatelessWidget {
  final TaskEntity task;
  final TaskBloc taskBloc;

  TaskDetailsPage({required this.task, required this.taskBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (task.deadline != null)
              Text(
                'Deadline: ${DateFormat.yMd().add_jm().format(task.deadline!)}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (task.subtasks.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: task.subtasks
                    .map((subtask) => Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(subtask.title),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 16),
            Text(
              'Status: ${task.completed ? 'Completed' : 'Incomplete'}',
              style: TextStyle(
                  fontSize: 16,
                  color: task.completed ? Colors.teal : Colors.black),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                taskBloc.deleteTask(task);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete Task',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
