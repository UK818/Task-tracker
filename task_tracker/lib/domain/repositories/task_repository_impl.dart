// lib/data/repositories/task_repository_impl.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String _tasksKey = 'tasks';

  @override
  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      final tasks = tasksJson.map((json) => TaskModel.fromJson(json)).toList();
      return tasks;
    } else {
      return [];
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TaskModel> tasks = await getTasks();
    tasks.add(task);
    prefs.setString(_tasksKey, jsonEncode(tasks));
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final prefs = await SharedPreferences.getInstance();
    List<TaskModel> tasks = await getTasks();
    tasks = tasks.map((t) => t.id == task.id ? task : t).toList();
    prefs.setString(_tasksKey, jsonEncode(tasks));
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    List<TaskModel> tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    prefs.setString(_tasksKey, jsonEncode(tasks));
  }
}
