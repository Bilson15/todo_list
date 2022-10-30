import 'package:flutter/material.dart';
import 'package:todo_list/app/components/button_component.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/ui/taks_page/controller/task_controller.dart';
import 'package:todo_list/theme/app_theme.dart';

class TaskPage extends StatelessWidget {
  final TaskModel? task;
  final controller = Get.put(TaskController());

  TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          task?.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: accentColor,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
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
                          backgroundColor: accentColor,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Seg: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Min: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Hour: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${controller.seconds}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                                  ),
                                  Text(
                                    '${controller.minutes}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                                  ),
                                  Text(
                                    '${controller.hours}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
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
                          '${task?.subtitle ?? ''} ',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ButtonComponent(
                          titulo: 'Pausar',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ButtonComponent(
                          titulo: 'Concluir',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
