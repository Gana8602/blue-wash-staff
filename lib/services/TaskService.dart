import 'dart:convert';

import 'package:blue_wash_staff/config/Data.dart';
import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/model/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  Future<dynamic> fetchTasks() async {
    var response = await http.post(Uri.parse("${config.base}${config.tasks}"),
        body: jsonEncode({'staff_token': Data.token}));

    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<TaskModel> tasks = list.map((e) => TaskModel.fromJson(e)).toList();
      for (var car in tasks) {
        Data.carNumbers.add(car.carNumber);
      }
      return tasks;
    } else {
      return null;
    }
  }
}
