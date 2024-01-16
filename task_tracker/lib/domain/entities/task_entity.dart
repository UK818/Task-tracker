import '../../data/models/task_model.dart';

class TaskEntity {
  final String id;
  final String title;
  final DateTime? deadline;
  final bool completed;
  final List<SubtaskEntity> subtasks;

  TaskEntity({
    required this.id,
    required this.title,
    required this.deadline,
    required this.completed,
    required this.subtasks,
  });

  TaskModel toModel() {
    return TaskModel(
      id: id,
      title: title,
      deadline: deadline,
      completed: completed,
      subtasks: subtasks.map((subtask) => subtask.toModel()).toList(),
    );
  }

  factory TaskEntity.fromModel(TaskModel model) {
    return TaskEntity(
      id: model.id,
      title: model.title,
      deadline: model.deadline,
      completed: model.completed,
      subtasks: model.subtasks
          .map((subtask) => SubtaskEntity.fromModel(subtask))
          .toList(),
    );
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    bool? completed,
    List<SubtaskEntity>? subtasks,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      completed: completed ?? this.completed,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

class SubtaskEntity {
  final String id;
  final String title;
  final bool completed;

  SubtaskEntity({
    required this.id,
    required this.title,
    required this.completed,
  });

  SubtaskModel toModel() {
    return SubtaskModel(id: id, title: title, completed: completed);
  }

  factory SubtaskEntity.fromModel(SubtaskModel model) {
    return SubtaskEntity(
        id: model.id, title: model.title, completed: model.completed);
  }
}
