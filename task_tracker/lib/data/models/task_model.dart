class TaskModel {
  final String id;
  final String title;
  final DateTime? deadline;
  final bool completed;
  final List<SubtaskModel> subtasks;

  TaskModel({
    required this.id,
    required this.title,
    required this.deadline,
    required this.completed,
    required this.subtasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline?.toIso8601String(),
      'completed': completed,
      'subtasks': subtasks.map((subtask) => subtask.toJson()).toList(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      completed: json['completed'],
      subtasks: (json['subtasks'] as List<dynamic>)
          .map((subtaskJson) => SubtaskModel.fromJson(subtaskJson))
          .toList(),
    );
  }
}

class SubtaskModel {
  final String id;
  final String title;
  final bool completed;

  SubtaskModel(
      {required this.id, required this.title, required this.completed});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
