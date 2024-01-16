import 'package:equatable/equatable.dart';
import 'package:task_tracker/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final TaskEntity task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskEntity updatedTask;

  UpdateTask(this.updatedTask);

  @override
  List<Object> get props => [updatedTask];
}

class DeleteTask extends TaskEvent {
  final TaskEntity task;

  DeleteTask(this.task);

  @override
  List<Object> get props => [task];
}
