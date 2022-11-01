import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/utils/api_services.dart';

class TaskRepository {
  late ApiService api;

  TaskRepository() {
    api = ApiService();
  }

  updateTask(TaskModel taskModel) async {
    var response = await api.put(
      '/TodoList',
      taskModel.toJson(),
    );

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(utf8.decode(response.body.codeUnits));

    //   List<TaskModel?> taks = data.map<TaskModel>((data) => TaskModel.fromJson(data)).toList();

    //   return taks;
    // } else {
    //   throw 'Ocorreu um erro!';
    // }
  }
}
