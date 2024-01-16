import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/domain/repositories/task_repository_impl.dart';
import 'package:task_tracker/domain/use%20cases/add_task_usecase.dart';
import 'package:task_tracker/domain/use%20cases/delete_task_usecase.dart';
import 'package:task_tracker/domain/use%20cases/get_task_usecase.dart';
import 'package:task_tracker/domain/use%20cases/update_task_usecase.dart';
import 'package:task_tracker/presentation/bloc/task_bloc.dart';
import 'package:task_tracker/presentation/pages/task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task tracker',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => TaskBloc(
          getTasksUsecase: GetTasksUsecase(TaskRepositoryImpl()),
          addTaskUsecase: AddTaskUsecase(TaskRepositoryImpl()),
          updateTaskUsecase: UpdateTaskUsecase(TaskRepositoryImpl()),
          deleteTaskUsecase: DeleteTaskUsecase(TaskRepositoryImpl()),
        ),
        child: TaskPage(),
      ),
    );
  }
}
