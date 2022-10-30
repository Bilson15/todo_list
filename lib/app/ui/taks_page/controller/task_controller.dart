import 'dart:async';

import 'package:get/get.dart';

class TaskController extends GetxController {
  final seconds = RxInt(60);
  final minutes = RxInt(60);
  final hours = RxInt(60);

  TaskController();

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (hours.value == 0 && minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
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
}
