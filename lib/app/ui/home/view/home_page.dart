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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openFormCreateTask();
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, size: 50),
      ),
      appBar: _buildAppBar(),
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
                  children: controller.listTaks.map(
                    (element) {
                      final item = element?.title ?? '';
                      return Dismissible(
                        key: Key(item),
                        onDismissed: (direction) {
                          TaskModel? taskRemoved = controller.removeIndex(element);

                          _buildAlertRemoveTask(context, taskRemoved);
                        },
                        background: _deleteIcon(),
                        direction: DismissDirection.startToEnd,
                        child: _buildListTile(element!),
                      );
                    },
                  ).toList(),
                ),
                onRefresh: () => controller.fetchTaks(),
              ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: const Text(
        'ToDo List',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      centerTitle: true,
      backgroundColor: accentColor,
    );
  }

  _buildAlertRemoveTask(context, TaskModel? taskRemoved) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${taskRemoved?.title ?? ''} dismissed'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            controller.insertTaskRemoved(taskRemoved!);
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
      selectedTileColor: taskModel.status.value == StatusEnum.finish.value ? accentColor : null,
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

  _openFormCreateTask() {
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
                  padding: const EdgeInsets.all(8.0),
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
                          },
                        ),
                        TextFormField(
                          controller: controller.description,
                          cursorColor: accentColor,
                          maxLength: 120,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            counterText: '',
                          ),
                        ),
                        TextFormField(
                          controller: controller.estimated,
                          inputFormatters: [controller.maskFormatter.hourFormat()],
                          cursorColor: accentColor,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: const InputDecoration(
                            labelText: 'Estimativa',
                            counterText: '',
                          ),
                          onChanged: (e) {
                            print(e.length);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Estimativa é obrigatório!';
                            }
                            if ((value?.length ?? 0) < 8) {
                              return 'Preencha por completo!';
                            }
                          },
                        ),
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
                      if (controller.formKey.currentState!.validate()) {
                        await controller.insertTaskCreate();
                        controller.clearFieldsCreate();
                        Get.back();
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
                                style: TextStyle(color: Colors.white),
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
