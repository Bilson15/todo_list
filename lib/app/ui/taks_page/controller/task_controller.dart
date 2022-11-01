import 'dart:async';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';

class TaskController extends GetxController {
  final seconds = RxInt(60);
  final minutes = RxInt(60);
  final hours = RxInt(60);

  late Timer timer;
  late final Rx<TaskModel?> task = Rx<TaskModel?>(null);

  TaskController(TaskModel task) {
    this.task.value = task;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void startTimer() {
    task.value!.status = StatusEnum.progress;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (hours.value == 0 && minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        task.value!.status = StatusEnum.stoped;
      } else {
        seconds.value--;
        if (seconds.value == 0) {
          if (minutes.value != 0) {
            seconds.value = 60;
          }
          if (minutes.value != 0) {
            minutes.value--;
          }
        }

        if (minutes.value == 0) {
          if (hours.value != 0) {
            minutes.value = 59;
          }
          if (hours.value != 0) {
            hours.value--;
          }
        }
      }
    });
  }

  void stopTimer() {
    timer.cancel();
    task.value!.status = StatusEnum.stoped;
    task.refresh();
  }
}
