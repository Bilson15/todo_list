import 'dart:async';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/app/model/timer_model.dart';
import 'package:todo_list/app/ui/home/controller/home_controller.dart';
import 'package:todo_list/app/ui/taks_page/repository/task_repository.dart';
import 'package:todo_list/utils/mask_formatter.dart';

class TaskController extends GetxController {
  final seconds = RxInt(60);
  final minutes = RxInt(0);
  final hours = RxInt(0);

  Timer? timer;
  Timer? timerLate;
  late final Rx<TaskModel?> task = Rx<TaskModel?>(null);

  late TimerModel? firstTimerModel = TimerModel(hour: 0, minute: 0, seconds: 0);
  late TimerModel? utilizedTimerModel = TimerModel(hour: 0, minute: 0, seconds: 0);
  late TimerModel? latedTimerModel = TimerModel(hour: 0, minute: 0, seconds: 0);
  final TaskRepository taskRepository = TaskRepository();

  final maskFormatter = MaskFormatter();

  final finalizing = RxBool(false);

  TaskController(TaskModel task) {
    this.task.value = task;
  }

  @override
  void onInit() {
    getTimers();
    super.onInit();
  }

  @override
  void onClose() async {
    if (task.value!.status != StatusEnum.finish) {
      await stopTimer();
    }
    Get.delete<TaskController>();
    super.onClose();
  }

  void startTimer() {
    if (task.value!.status != StatusEnum.progress) {
      task.value!.status = StatusEnum.progress;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (hours.value == 0 && minutes.value == 0 && seconds.value == 0) {
          timer.cancel();
          updateTask();
          task.value!.lated = true;
          runTimer();
        } else {
          seconds.value--;

          if (minutes.value == firstTimerModel?.minute) {
            if (hours.value == firstTimerModel?.hour && minutes.value == 0) {
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
  }

  void startTimerLate() {
    if (task.value!.status != StatusEnum.progress || (task.value!.lated ?? false)) {
      task.value!.status = StatusEnum.progress;
      timerLate = Timer.periodic(const Duration(seconds: 1), (timer) {
        seconds.value++;

        if (seconds.value == 60) {
          seconds.value = 0;
          if (minutes.value != 60) {
            minutes.value++;
          }
        }

        if (minutes.value == 60) {
          minutes.value = 0;
          hours.value++;
        }
      });
    }
  }

  Future<void> stopTimer() async {
    if (timerLate != null) {
      if (task.value!.lated ?? false) timerLate!.cancel();
    }

    if (timer != null) {
      timer!.cancel();
    }

    task.value!.status = StatusEnum.stoped;
    task.refresh();
    await updateTask();
  }

  Future<void> runTimer() async {
    if (task.value?.lated ?? false) {
      startTimerLate();
    } else {
      startTimer();
    }
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

  getLatedTimer() {
    if (task.value != null && task.value?.timeLate != null) {
      List<String> latedTimer = task.value!.timeLate!.split(':');

      if (latedTimer.length == 3) {
        latedTimerModel =
            TimerModel(hour: int.parse(latedTimer[0]), minute: int.parse(latedTimer[1]), seconds: int.parse(latedTimer[2]));
      }
    }
  }

  getTimers() {
    getInitialTimer();
    getUtilizedTimer();
    getLatedTimer();

    if (task.value != null) {
      if (task.value!.timeLate!.isNotEmpty) {
        hours.value = latedTimerModel?.hour ?? 0;
        minutes.value = latedTimerModel?.minute ?? 0;
        seconds.value = latedTimerModel?.seconds ?? 0;
      } else if (task.value?.timeUtilized != null) {
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
    if (task.value?.lated ?? false) {
      task.value?.timeLate = '${hours.value}:${minutes.value}:${seconds.value}';
    }

    if (!(task.value?.lated ?? false)) {
      task.value?.timeUtilized = '${hours.value}:${minutes.value}:${seconds.value}';
    }
  }

  updateTask() async {
    try {
      if (task.value != null) {
        preparTimerTaskToUpdate();
        await taskRepository.updateTask(task.value!);
      }
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {}
  }

  Future<void> completeTask() async {
    try {
      finalizing(true);
      await stopTimer();
      task.value!.status = StatusEnum.finish;
      await updateTask();
      getTimers();
    } catch (e) {
      Get.snackbar("Ops", "ocorreu um erro.");
    } finally {
      _updateListTaskFromHomePage();
      finalizing(false);
    }
  }

  _updateListTaskFromHomePage() {
    final controller = Get.find<HomePageController>();
    controller.fetchTaks();
  }
}
