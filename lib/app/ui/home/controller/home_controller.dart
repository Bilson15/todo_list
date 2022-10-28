import 'package:get/get.dart';

class HomePageController extends GetxController {
  final RxList items = RxList<String>.generate(20, (i) => 'Item ${i + 1}');

  HomePageController();
}
