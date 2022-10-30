class TaskModel {
  TaskModel({
    this.id,
    this.title,
    this.subtitle,
    this.timer,
    this.timeUtilized,
    this.status,
  });
  late final int? id;
  late final String? title;
  late final String? subtitle;
  late final String? timer;
  late final String? timeUtilized;
  late final bool? status;

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    title = json['title'];
    subtitle = json['subtitle'];
    timer = json['timer'];
    timeUtilized = json['timeUtilized'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timer': timer,
      'timeUtilized': timeUtilized,
      'status': status,
    };
  }
}
