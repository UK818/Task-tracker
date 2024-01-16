import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/domain/use%20cases/delete_task_usecase.dart';
import 'package:task_tracker/domain/use%20cases/update_task_usecase.dart';
import 'package:task_tracker/presentation/bloc/task_events.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/use cases/add_task_usecase.dart';
import '../../domain/use cases/get_task_usecase.dart';

part 'task_state.dart';

class TaskBloc extends Cubit<TaskState> {
  final GetTasksUsecase getTasksUsecase;
  final AddTaskUsecase addTaskUsecase;
  final UpdateTaskUsecase updateTaskUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;

  TaskBloc({
    required this.getTasksUsecase,
    required this.addTaskUsecase,
    required this.updateTaskUsecase,
    required this.deleteTaskUsecase,
  }) : super(TaskInitial());

  void loadTasks() async {
    final tasks = await getTasksUsecase.execute();
    emit(TaskLoaded(tasks));
  }

  void addTask(TaskEntity task) async {
    await addTaskUsecase.execute(task);
    loadTasks();
  }

  void updateTask(TaskEntity updatedTask) async {
    await updateTaskUsecase.execute(updatedTask);
    loadTasks();
  }

  void deleteTask(TaskEntity task) async {
    await deleteTaskUsecase.execute(task);
    loadTasks();
  }

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTasksToState();
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(event);
    } else if (event is UpdateTask) {
      yield* _mapUpdateTaskToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    }
  }

  Stream<TaskState> _mapLoadTasksToState() async* {
    try {
      final tasks = await getTasksUsecase.execute();
      yield TaskLoaded(tasks);
    } catch (e) {
      yield TaskError('Failed to load tasks');
    }
  }

  Stream<TaskState> _mapAddTaskToState(AddTask event) async* {
    try {
      await addTaskUsecase.execute(event.task);
      yield* _mapLoadTasksToState();
    } catch (e) {
      yield TaskError('Failed to add task');
    }
  }

  Stream<TaskState> _mapUpdateTaskToState(UpdateTask event) async* {
    try {
      await updateTaskUsecase.execute(event.updatedTask);
      yield* _mapLoadTasksToState();
    } catch (e) {
      yield TaskError('Failed to update task');
    }
  }

  Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
    try {
      await deleteTaskUsecase.execute(event.task);
      yield* _mapLoadTasksToState();
    } catch (e) {
      yield TaskError('Failed to delete task');
    }
  }
}
