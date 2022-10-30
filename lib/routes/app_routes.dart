import 'package:get/get.dart';
import 'package:todo_list/app/ui/home/binding/home_binding.dart';
import 'package:todo_list/app/ui/home/view/home_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
