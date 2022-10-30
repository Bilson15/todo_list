import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/theme/app_theme.dart';

class TaskPage extends StatelessWidget {
  final TaskModel? task;

  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          task?.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
      ),
    );
  }
}
