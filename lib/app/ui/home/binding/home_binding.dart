import 'package:get/get.dart';
import 'package:todo_list/app/ui/home/controller/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController(), fenix: true);
  }
}
