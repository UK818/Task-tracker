import '../../data/repositories/task_repository.dart';
import '../entities/task_entity.dart';

class GetTasksUsecase {
  final TaskRepository repository;

  GetTasksUsecase(this.repository);

  Future<List<TaskEntity>> execute() async {
    final tasks = await repository.getTasks();
    return tasks.map((task) => TaskEntity.fromModel(task)).toList();
  }
}
