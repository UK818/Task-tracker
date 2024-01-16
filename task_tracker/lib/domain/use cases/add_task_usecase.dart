import '../../data/repositories/task_repository.dart';
import '../entities/task_entity.dart';

class AddTaskUsecase {
  final TaskRepository repository;

  AddTaskUsecase(this.repository);

  Future<void> execute(TaskEntity task) async {
    final taskModel = task.toModel();
    await repository.addTask(taskModel);
  }
}
