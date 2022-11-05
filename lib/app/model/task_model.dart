import 'package:todo_list/app/model/status_enum.dart';

class TaskModel {
  TaskModel({
    this.id,
    this.title,
    this.subtitle,
    this.timer,
    this.timeUtilized,
    this.lated,
    required this.status,
  });
  late final int? id;
  late final String? title;
  late final String? subtitle;
  late final String? timer;
  late String? timeUtilized = '';
  late String? timeLate = '';
  late StatusEnum status;
  late bool? lated = false;

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    title = json['title'];
    subtitle = json['subtitle'];
    timer = json['timer'];
    timeUtilized = json['timeUtilized'];
    status = statusHelper(json['status']);
    lated = json['lated'];
    timeLate = json['timeLate'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timer': timer,
      'timeUtilized': timeUtilized,
      'status': status.value,
      'lated': lated,
      'timeLate': timeLate,
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
