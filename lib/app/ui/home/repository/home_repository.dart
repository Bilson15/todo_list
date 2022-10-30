import 'dart:convert';

import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/utils/api_services.dart';

class HomeRepository {
  late ApiService api;

  HomeRepository() {
    api = ApiService();
  }

  Future<List<TaskModel?>> fetchTaks() async {
    var response = await api.get(
      '/TodoList',
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.body.codeUnits));

      List<TaskModel?> taks = data.map<TaskModel>((data) => TaskModel.fromJson(data)).toList();

      return taks;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<TaskModel?> insertTask(TaskModel task) async {
    var response = await api.post(
      '/TodoList/',
      task.toJson(),
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      TaskModel? cliente = TaskModel.fromJson(data);

      return cliente;
    } else {
      var error = json.decode(response.body)['message'];
      throw error;
    }
  }

  Future<bool> deleteTask(int id) async {
    var response = await api.delete(
      '/TodoList/$id',
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
