import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/ui/home/controller/home_controller.dart';
import 'package:todo_list/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAlertBox();
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, size: 50),
      ),
      appBar: AppBar(
          title: const Text(
            'ToDo List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: accentColor),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                controller.items.removeAt(index);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              background: Container(
                color: accentColor,
                child: const Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              direction: DismissDirection.startToEnd,
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
      ),
    );
  }

  openAlertBox() {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.only(top: 10.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nova tarefa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: accentColor,
              ),
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.close,
                color: accentColor,
                size: 30,
              ),
            ),
          ],
        ),
        content: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: accentColor,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                        ),
                      ),
                      TextFormField(
                        cursorColor: accentColor,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
                      ),
                      TextFormField(
                        cursorColor: accentColor,
                        decoration: const InputDecoration(
                          labelText: 'Estimativa',
                        ),
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
                  onTap: () {
                    print('Criou');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius:
                          const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Criar",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
