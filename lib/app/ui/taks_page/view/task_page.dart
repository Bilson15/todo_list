import 'package:flutter/material.dart';
import 'package:todo_list/app/components/button_component.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/ui/taks_page/controller/task_controller.dart';
import 'package:todo_list/theme/app_theme.dart';

class TaskPage extends StatelessWidget {
  final TaskModel task;

  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController(task));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.task.value?.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: controller.finalizing.value
              ? SizedBox(
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
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Center(
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: 1 - controller.seconds / 60,
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 12,
                                backgroundColor: (controller.task.value?.lated ?? false) ? orange : accentColor,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${controller.seconds}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 120),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${controller.hours}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                        ),
                                        const Text(
                                          ':',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                        ),
                                        Text(
                                          '${controller.minutes}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: gray),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
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
                              Text(
                                '${controller.task.value?.subtitle ?? ''} ',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        thickness: 2,
                        color: graySecundary,
                      ),
                    ),
                    Obx(
                      () => (controller.task.value?.status.value ?? false) != StatusEnum.finish.value
                          ? Padding(
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
                                              backgroundColor: orange,
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
                                              onPressed: () {
                                                controller.startTimer();
                                              },
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => (controller.task.value?.status.value ?? false) != StatusEnum.finish.value
                          ? Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(gray),
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
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
