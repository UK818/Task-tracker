import 'package:task_tracker/data/repositories/task_repository.dart';

import '../entities/task_entity.dart';

class UpdateTaskUsecase {
  final TaskRepository repository;

  UpdateTaskUsecase(this.repository);

  Future<void> execute(TaskEntity updatedTask) async {
    final taskModel = updatedTask.toModel();
    await repository.updateTask(taskModel);
  }
}
