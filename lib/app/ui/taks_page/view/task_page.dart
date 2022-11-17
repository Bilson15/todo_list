import 'package:flutter/material.dart';
import 'package:todo_list/app/components/button_component.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/ui/taks_page/controller/task_controller.dart';
import 'package:todo_list/theme/app_theme.dart';

class TaskPage extends StatelessWidget {
  final TaskModel task;
  late final TaskController controller;

  TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    controller = Get.put(TaskController(task));
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => SingleChildScrollView(
          child: controller.finalizing.value
              ? buildLoading()
              : Column(
                  children: [
                    _buildStopWatch(),
                    _buildDescription(),
                    _buildDivider(),
                    Obx(
                      () => (controller.task.value?.status.value ?? false) != StatusEnum.finish.value
                          ? _buildButtons()
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => (controller.task.value?.status.value ?? false) != StatusEnum.finish.value
                          ? _buildCompleteTaskButton()
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => (controller.task.value?.status.value ?? false) == StatusEnum.finish.value
                          ? _buildInfoCompletedTask()
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
        ),
      ),
    );
  }

  _buildDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        thickness: 2,
        color: graySecundary,
      ),
    );
  }

  _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Descrição: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  '${controller.task.value?.subtitle ?? ''} ',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildCompleteTaskButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(accentColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  ),
                ),
              ),
              onPressed: () async {
                await controller.completeTask();
              },
              child: const Text(
                'Concluir',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInfoCompletedTask() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Icon(Icons.schedule, size: 35, color: graySecundary),
              const Text(
                'Estimado',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: graySecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${controller.maskFormatter.formatPaddingLeftZero(controller.firstTimerModel?.hour ?? 0)}:${controller.maskFormatter.formatPaddingLeftZero(controller.firstTimerModel?.minute ?? 0)}:00',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: gray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.timer_outlined, size: 35, color: graySecundary),
              const Text(
                'Utilizado',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: graySecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${controller.maskFormatter.formatPaddingLeftZero(controller.utilizedTimerModel?.hour ?? 0)}:${controller.maskFormatter.formatPaddingLeftZero(controller.utilizedTimerModel?.minute ?? 0)}:${controller.maskFormatter.formatPaddingLeftZero(controller.utilizedTimerModel?.seconds ?? 0)}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: gray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.timer_off_outlined, size: 35, color: graySecundary),
              const Text(
                'Atraso',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  color: graySecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '${controller.maskFormatter.formatPaddingLeftZero(controller.latedTimerModel?.hour ?? 0)}:${controller.maskFormatter.formatPaddingLeftZero(controller.latedTimerModel?.minute ?? 0)}:${controller.maskFormatter.formatPaddingLeftZero(controller.latedTimerModel?.seconds ?? 0)}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: gray,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          (controller.task.value?.status.value ?? false) == StatusEnum.stoped.value
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ButtonComponent(
                      titulo: 'Continuar',
                      onPressed: () {
                        controller.runTimer();
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          (controller.task.value?.status.value ?? false) == StatusEnum.progress.value
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ButtonComponent(
                      titulo: 'Pausar',
                      onPressed: () {
                        controller.stopTimer();
                      },
                      backgroundColor: graySecundary,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          (controller.task.value?.status) == StatusEnum.init
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ButtonComponent(
                      titulo: 'Iniciar',
                      onPressed: () async {
                        await controller.runTimer();
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  buildLoading() {
    return SizedBox(
      height: Get.height - 85,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: accentColor,
          ),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        controller.task.value?.title ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      centerTitle: true,
      backgroundColor: accentColor,
    );
  }

  _buildStopWatch() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 320,
        width: 320,
        child: Stack(
          children: [
            Positioned(
              left: 235,
              top: 48,
              child: CustomPaint(
                size: Size(
                  90,
                  (88 * 0.58).toDouble(),
                ),
                painter: RPSCustomPainter((controller.task.value?.lated ?? false) ? yellow : accentColor),
              ),
            ),
            Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: (controller.task.value?.status ?? false) != StatusEnum.finish
                          ? 1 - controller.seconds / 60
                          : 1 - 60 / 60,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 12,
                      backgroundColor: (controller.task.value?.lated ?? false) ? yellow : accentColor,
                    ),
                    Center(
                      child: (controller.task.value?.status ?? false) == StatusEnum.finish
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: (controller.task.value?.lated ?? false) ? yellow : accentColor,
                                  size: 85,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.maskFormatter.formatPaddingLeftZero(controller.seconds.value),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 120, color: gray),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.maskFormatter.formatPaddingLeftZero(controller.hours.value),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                    ),
                                    const Text(
                                      ':',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                    ),
                                    Text(
                                      controller.maskFormatter.formatPaddingLeftZero(controller.minutes.value),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 138,
              top: 6,
              child: Container(
                height: 15,
                width: 45,
                decoration: BoxDecoration(
                  color: (controller.task.value?.lated ?? false) ? yellow : accentColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  late final Color color;

  RPSCustomPainter(this.color);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Paint paint0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.2083333, size.height * 0.4285714);
    path0.lineTo(size.width * 0.2916667, size.height * 0.5700000);
    path0.lineTo(size.width * 0.5010333, size.height * 0.2163143);
    path0.lineTo(size.width * 0.4161667, size.height * 0.0708429);
    path0.lineTo(size.width * 0.2083333, size.height * 0.4285714);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
