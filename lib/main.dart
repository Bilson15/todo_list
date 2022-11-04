import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/routes/app_routes.dart';
import 'package:todo_list/theme/app_theme.dart';

void main() async {
  runApp(
    GetMaterialApp(
      title: 'ToDo List',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppRoutes.routes,
      theme: appTheme,
    ),
  );
}
