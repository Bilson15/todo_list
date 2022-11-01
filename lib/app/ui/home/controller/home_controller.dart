import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/app/ui/home/repository/home_repository.dart';
import 'package:todo_list/utils/mask_formatter.dart';

class HomePageController extends GetxController {
  final maskFormatter = MaskFormatter();
  final homeRepository = HomeRepository();
  final listTaks = RxList<TaskModel?>([]);
  final formKey = GlobalKey<FormState>();

  late final title = TextEditingController();
  late final description = TextEditingController();
  late final estimated = TextEditingController();

  final creating = RxBool(false);
  final loading = RxBool(false);

  HomePageController();

  @override
  void onInit() async {
    await fetchTaks();

    super.onInit();
  }

  Future<void> fetchTaks() async {
    listTaks.clear();
    loading(true);
    try {
      List<TaskModel?> retorno = await homeRepository.fetchTaks();

      listTaks.addAll(retorno);
    } catch (e) {
      print(e);
    } finally {
      await _refrashListOrdem();
      loading(false);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await homeRepository.deleteTask(id);
    } catch (e) {
      print(e);
    } finally {
      await fetchTaks();
    }
  }

  Future<void> insertTaskRemoved(TaskModel taskModel) async {
    try {
      await homeRepository.insertTask(taskModel);
    } catch (e) {
      print(e);
    } finally {
      await fetchTaks();
    }
  }

  Future<void> insertTaskCreate() async {
    creating(true);
    try {
      final taskModel = TaskModel(
        title: title.text,
        subtitle: description.text,
        timer: estimated.text,
        status: StatusEnum.init,
      );

      await homeRepository.insertTask(taskModel);
    } catch (e) {
      print(e);
    } finally {
      await fetchTaks();
      creating(false);
    }
  }

  clearFieldsCreate() {
    title.clear();
    description.clear();
    estimated.clear();
  }

  Future<void> _refrashListOrdem() async {
    await Future.delayed(const Duration(seconds: 1));

    listTaks.sort((a, b) {
      if ((a?.status.value == StatusEnum.finish.value) || (a?.status.value == StatusEnum.finish.value)) {
        return 1;
      } else {
        return 0;
      }
    });

    listTaks.refresh();
  }

  TaskModel? removeIndex(TaskModel taskModel) {
    listTaks.remove(taskModel);
    deleteTask(taskModel.id ?? -1);

    return taskModel;
  }
}
