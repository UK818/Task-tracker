import '../../data/repositories/task_repository.dart';
import '../entities/task_entity.dart';

class DeleteTaskUsecase {
  final TaskRepository repository;

  DeleteTaskUsecase(this.repository);

  Future<void> execute(TaskEntity task) async {
    final taskId = task.id; // Assuming TaskEntity has an 'id' property
    await repository.deleteTask(taskId);
  }
}
