import 'package:todo_list/app/model/status_enum.dart';

class TaskModel {
  TaskModel({
    this.id,
    this.title,
    this.subtitle,
    this.timer,
    this.timeUtilized,
    required this.status,
  });
  late final int? id;
  late final String? title;
  late final String? subtitle;
  late final String? timer;
  late final String? timeUtilized;
  late StatusEnum status;

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    title = json['title'];
    subtitle = json['subtitle'];
    timer = json['timer'];
    timeUtilized = json['timeUtilized'];
    status = statusHelper(json['status']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timer': timer,
      'timeUtilized': timeUtilized,
      'status': status.value,
    };
  }

  StatusEnum statusHelper(int status) {
    switch (status) {
      case 1:
        return StatusEnum.init;
      case 2:
        return StatusEnum.progress;
      case 3:
        return StatusEnum.stoped;
      case 4:
        return StatusEnum.finish;
      default:
        return StatusEnum.init;
    }
  }
}
