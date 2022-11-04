import 'dart:async';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/app/model/timer_model.dart';
import 'package:todo_list/app/ui/taks_page/repository/task_repository.dart';

class TaskController extends GetxController {
  final seconds = RxInt(60);
  final minutes = RxInt(0);
  final hours = RxInt(0);

  late Timer timer;
  late final Rx<TaskModel?> task = Rx<TaskModel?>(null);

  late final TimerModel? firstTimerModel;
  late final TimerModel? utilizedTimerModel;
  final TaskRepository taskRepository = TaskRepository();

  TaskController(TaskModel task) {
    this.task.value = task;
  }

  @override
  void onInit() {
    getTimers();
    super.onInit();
  }

  @override
  void onClose() {
    if (task.value!.status != StatusEnum.finish) {
      stopTimer();
    }
    super.onClose();
  }

  void startTimer() {
    task.value!.status = StatusEnum.progress;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (hours.value == 0 && minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        task.value!.status = StatusEnum.stoped;
      } else {
        seconds.value--;

        if (minutes.value == firstTimerModel?.minute) {
          if (hours.value == firstTimerModel?.hour) {
            hours.value--;
            minutes.value = 59;
          } else {
            minutes.value--;
          }
        }

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
    updateTask();
  }

  getInitialTimer() {
    if (task.value != null) {
      if (task.value?.timer != null) {
        List<String> initialTimer = task.value!.timer!.split(':');
        if (initialTimer.length == 2) {
          firstTimerModel = TimerModel(hour: int.parse(initialTimer[0]), minute: int.parse(initialTimer[1]));
        }
      }
    }
  }

  getUtilizedTimer() {
    if (task.value != null && task.value?.timeUtilized != null) {
      List<String> utilizedTimer = task.value!.timeUtilized!.split(':');

      if (utilizedTimer.length == 3) {
        utilizedTimerModel = TimerModel(
            hour: int.parse(utilizedTimer[0]), minute: int.parse(utilizedTimer[1]), seconds: int.parse(utilizedTimer[2]));
      }
    }
  }

  getTimers() {
    getInitialTimer();
    getUtilizedTimer();

    if (task.value != null) {
      if (task.value?.timeUtilized != null) {
        hours.value = utilizedTimerModel?.hour ?? 0;
        minutes.value = utilizedTimerModel?.minute ?? 0;
        seconds.value = utilizedTimerModel?.seconds ?? 0;
      } else {
        hours.value = firstTimerModel?.hour ?? 0;
        minutes.value = firstTimerModel?.minute ?? 0;
      }
    }
  }

  preparTimerTaskToUpdate() {
    task.value?.timeUtilized = '${hours.value}:${minutes.value}:${seconds.value}';
  }

  updateTask() async {
    try {
      if (task.value != null) {
        preparTimerTaskToUpdate();
        await taskRepository.updateTask(task.value!);
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  completeTask() {
    task.value!.status = StatusEnum.stoped;
    task.value!.status = StatusEnum.finish;
    updateTask();
  }
}
