import 'package:task_app_116/view_model/data/local/shared_helper.dart';
import 'package:task_app_116/view_model/data/local/shared_keys.dart';

class Task {
  String? id;
  String? title;
  String? description;
  String? image;
  String? startDate;
  String? endDate;
  String? status;
  String? userUid;

  Task({
    this.id,
    this.title,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.status,
    this.userUid,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    userUid = json['user_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (id != null) data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    if ((image ?? '').isNotEmpty) data['image'] = image;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['user_uid'] = SharedHelper.getData(SharedKeys.uid);
    return data;
  }

  Task.copyWith(Task task) {
    id = task.id ?? id;
    title = task.title ?? title;
    description = task.description ?? description;
    image = task.image ?? image;
    startDate = task.startDate ?? startDate;
    endDate = task.endDate ?? endDate;
    status = task.status ?? status;
    userUid = task.userUid ?? userUid;
  }
}
