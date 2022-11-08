import 'dart:convert';

import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/utils/api_services.dart';

class TaskRepository {
  late ApiService api;

  TaskRepository() {
    api = ApiService();
  }

  updateTask(TaskModel taskModel) async {
    var response = await api.put(
      '/TodoList/${taskModel.id}',
      taskModel.toJson(),
    );

    if (response.statusCode == 200) {
      jsonDecode(utf8.decode(response.body.codeUnits));
    } else {
      throw 'Ocorreu um erro!';
    }
  }
}
