import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/model/status_enum.dart';
import 'package:todo_list/app/model/task_model.dart';
import 'package:todo_list/app/ui/home/controller/home_controller.dart';
import 'package:todo_list/app/ui/taks_page/view/task_page.dart';
import 'package:todo_list/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildCreateTaskButton(context),
      appBar: _buildAppBar(context),
      body: Obx(
        () => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: accentColor,
                ),
              )
            : RefreshIndicator(
                color: accentColor,
                child: ListView(
                  children: controller.listTasks.isNotEmpty
                      ? controller.listTasks.map(
                          (element) {
                            final item = element?.title ?? '';
                            return Dismissible(
                              key: Key(item),
                              onDismissed: (direction) async {
                                TaskModel? taskRemoved = await controller.removeIndex(element);

                                _buildAlertRemoveTask(context, taskRemoved);
                              },
                              background: _deleteIcon(),
                              direction: DismissDirection.startToEnd,
                              child: _buildListTile(element!),
                            );
                          },
                        ).toList()
                      : _buildEmptyList(),
                ),
                onRefresh: () => controller.fetchTaks(),
              ),
      ),
    );
  }

  _buildCreateTaskButton(context) {
    return FloatingActionButton(
      onPressed: () {
        _openFormCreateTask(context);
      },
      backgroundColor: accentColor,
      child: const Icon(Icons.add, size: 50),
    );
  }

  PreferredSizeWidget? _buildAppBar(context) {
    return AppBar(
      title: const Text(
        'To Do List',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      centerTitle: true,
      backgroundColor: accentColor,
      actions: [
        GestureDetector(
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: const Text(
                  'Aviso',
                  style: TextStyle(color: accentColor),
                ),
                content: const Text(
                  'Deseja excluir todas as suas tarefas do registro ?',
                  style: TextStyle(color: accentColor),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Não",
                      style: TextStyle(color: accentColor),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  TextButton(
                    child: const Text(
                      "Sim",
                      style: TextStyle(color: accentColor),
                    ),
                    onPressed: () async {
                      Get.back();
                      await controller.deleteAllTasks();
                    },
                  ),
                ],
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.delete,
            ),
          ),
        ),
      ],
    );
  }

  _buildThemePickTime() {
    return TimePickerThemeData(
      backgroundColor: graySecundary,
      dayPeriodTextColor: Colors.white,
      hourMinuteColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.selected) ? accentColor : Colors.blueGrey.shade800),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) => Colors.white),
      dialHandColor: Colors.blueGrey.shade700,
      dialBackgroundColor: Colors.blueGrey.shade800,
      hourMinuteTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      dayPeriodTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      helpTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      dialTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? yellow : Colors.white),
    );
  }

  _buildAlertRemoveTask(context, TaskModel? taskRemoved) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${taskRemoved?.title ?? ''} dismissed'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () async {
            await controller.insertTaskRemoved(taskRemoved!);
          },
        ),
      ),
    );
  }

  Widget _deleteIcon() {
    return Container(
      color: accentColor,
      child: const Align(
        alignment: Alignment(-0.9, 0.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildListTile(TaskModel taskModel) {
    return ListTile(
      selected: taskModel.status.value == StatusEnum.finish.value,
      selectedTileColor: taskModel.status.value == StatusEnum.finish.value
          ? (taskModel.lated ?? false)
              ? yellow
              : accentColor
          : null,
      leading: taskModel.status.value == StatusEnum.finish.value ? const Icon(Icons.check) : null,
      selectedColor: taskModel.status.value == StatusEnum.finish.value ? Colors.white : null,
      title: Text(
        taskModel.title ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(taskModel.subtitle ?? 'Sem descrição'),
      onTap: () => Get.to(
        () => TaskPage(
          task: taskModel,
        ),
      ),
    );
  }

  List<Widget> _buildEmptyList() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: const [
            Icon(Icons.cancel, color: graySecundary, size: 50),
            SizedBox(
              height: 12,
            ),
            Text(
              'Nenhuma tarefa cadastrada no momento, vamos começar ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: graySecundary,
              ),
            ),
          ],
        ),
      )
    ];
  }

  _openFormCreateTask(context) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 20.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nova tarefa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: accentColor,
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.close,
                color: accentColor,
                size: 30,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.title,
                          cursorColor: accentColor,
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                            counterText: '',
                          ),
                          validator: (value) {
                            if (controller.title.text.isEmpty) {
                              return 'Título é obrigatório!';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: controller.description,
                          cursorColor: accentColor,
                          maxLength: 120,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            counterText: '',
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () async {
                            controller.timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: controller.timeOfDay ?? const TimeOfDay(hour: 00, minute: 30),
                              initialEntryMode: TimePickerEntryMode.dialOnly,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    timePickerTheme: _buildThemePickTime(),
                                    textButtonTheme: TextButtonThemeData(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (controller.timeOfDay != null) {
                              controller.estimated.value =
                                  '${controller.maskFormatter.formatPaddingLeftZero(controller.timeOfDay!.hour)}:${controller.maskFormatter.formatPaddingLeftZero(controller.timeOfDay!.minute)}';
                            }
                          },
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Selecionar Estimativa: ',
                                  style: TextStyle(
                                    color: accentColor,
                                  ),
                                ),
                                Text(
                                  controller.estimated.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      color: accentColor, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                  child: const Icon(
                                    Icons.timer_outlined,
                                    color: yellow,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  child: GestureDetector(
                    onTap: () async {
                      controller.formKey.currentState!.save();
                      if (controller.formKey.currentState!.validate() && controller.estimated.value.isNotEmpty) {
                        Get.back();
                        await controller.insertTaskCreate();
                        controller.clearFieldsCreate();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: const BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Obx(
                        () => controller.creating.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Criar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
