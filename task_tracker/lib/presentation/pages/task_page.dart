import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker/presentation/pages/task_detail_page.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';

class TaskPage extends StatelessWidget {
  TaskBloc? taskBloc;
  @override
  Widget build(BuildContext context) {
    taskBloc = context.read<TaskBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task tracker'),
        backgroundColor: Colors.teal,
      ),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTaskDialog(context),
        tooltip: 'Add Task',
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(taskBloc: taskBloc!);
      },
    );
  }
}

class TaskList extends StatelessWidget {
  TaskBloc? taskBloc;
  @override
  Widget build(BuildContext context) {
    taskBloc = context.read<TaskBloc>();
    if (taskBloc != null) {
      taskBloc?.loadTasks();
    }
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        print('State is $state');
        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'No tasks available. Tap the "+" button to add a task.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskListItem(
                task: task,
                taskBloc: taskBloc!,
              );
            },
          );
        } else if (state is TaskInitial) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('ADD TASK'));
        }
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final TaskEntity task;
  final TaskBloc taskBloc;

  TaskListItem({required this.task, required this.taskBloc});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        context.read<TaskBloc>().deleteTask(task);
      },
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: task.completed ? FontWeight.normal : FontWeight.bold,
            color: task.completed ? Colors.teal : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.deadline != null)
              Text('Deadline: ${DateFormat.yMd().format(task.deadline!)}'),
            if (task.subtasks.isNotEmpty)
              Text('Description: ${task.subtasks[0].title}'),
            if (task.subtasks.isEmpty)
              const Icon(Icons.remove_circle_outline, color: Colors.grey),
          ],
        ),
        trailing: Checkbox(
          activeColor: Colors.teal,
          value: task.completed,
          onChanged: (value) {
            context
                .read<TaskBloc>()
                .updateTask(task.copyWith(completed: value));
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return TaskDetailsPage(
                  task: task,
                  taskBloc: taskBloc,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final TaskBloc taskBloc;
  AddTaskDialog({required this.taskBloc});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();
  DateTime? _selectedDeadline;
  bool pickedDate = false;
  String dateHeader = 'Select Deadline';
  List<String> _subtasks = [];

  @override
  Widget build(BuildContext context) {
    dateHeader = pickedDate
        ? 'Deadline: ${DateFormat.yMd().format(_selectedDeadline!)}'
        : 'Select Deadline';
    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.teal.shade100,
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _selectedDeadline) {
                setState(() {
                  _selectedDeadline = picked;
                  pickedDate = true;
                });
              }
            },
            child: Text(dateHeader),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _subtaskController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _addTask();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addTask() {
    final title = _titleController.text.trim();
    final subtask = _subtaskController.text.trim();

    if (title.isNotEmpty) {
      _subtasks.add(subtask);

      widget.taskBloc.addTask(TaskEntity(
        id: UniqueKey().toString(),
        title: title,
        deadline: _selectedDeadline,
        completed: false,
        subtasks: _subtasks
            .map((subtaskTitle) => SubtaskEntity(
                  id: UniqueKey().toString(),
                  title: subtaskTitle,
                  completed: false,
                ))
            .toList(),
      ));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
