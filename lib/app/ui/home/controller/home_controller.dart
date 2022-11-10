import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/app/ui/home/repository/home_repository.dart';
import 'package:todo_list/utils/mask_formatter.dart';

class HomePageController extends GetxController {
  final maskFormatter = MaskFormatter();
  final homeRepository = HomeRepository();
  final listTasks = RxList<TaskModel?>([]);
  final formKey = GlobalKey<FormState>();

  late final title = TextEditingController();
  late final description = TextEditingController();
  late final estimated = RxString('');
  late TimeOfDay? timeOfDay = const TimeOfDay(hour: 00, minute: 30);

  final creating = RxBool(false);
  final loading = RxBool(false);

  HomePageController();

  @override
  void onInit() async {
    await fetchTaks();

    super.onInit();
  }

  Future<void> fetchTaks() async {
    listTasks.clear();
    loading(true);
    try {
      List<TaskModel?> retorno = await homeRepository.fetchTaks();

      listTasks.addAll(retorno);
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      await _refrashListOrdem();
      loading(false);
    }
  }

  Future<void> deleteTask(int id) async {
    loading(true);
    try {
      await homeRepository.deleteTask(id);
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      await fetchTaks();
    }
  }

  Future<void> insertTaskRemoved(TaskModel taskModel) async {
    loading(true);
    try {
      await homeRepository.insertTask(taskModel);
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      await fetchTaks();
    }
  }

  Future<void> insertTaskCreate() async {
    creating(true);
    try {
      final taskModel =
          TaskModel(title: title.text, subtitle: description.text, timer: estimated.value, status: StatusEnum.init, lated: false);
      await homeRepository.insertTask(taskModel);
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      await fetchTaks();
      creating(false);
    }
  }

  clearFieldsCreate() {
    title.clear();
    description.clear();
    estimated.value = '';
    timeOfDay = const TimeOfDay(hour: 00, minute: 30);
  }

  Future<void> _refrashListOrdem() async {
    await Future.delayed(const Duration(seconds: 1));

    listTasks.sort((a, b) {
      if ((a?.status.value == StatusEnum.finish.value) || (a?.status.value == StatusEnum.finish.value)) {
        return 1;
      } else {
        return 0;
      }
    });

    listTasks.refresh();
  }

  Future<TaskModel?> removeIndex(TaskModel taskModel) async {
    listTasks.remove(taskModel);
    await deleteTask(taskModel.id ?? -1);

    return taskModel;
  }

  Future<void> deleteAllTasks() async {
    try {
      loading(true);

      for (final task in listTasks) {
        await homeRepository.deleteTask(task?.id ?? -1);
      }
      await fetchTaks();
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      loading(false);
    }
  }
}
