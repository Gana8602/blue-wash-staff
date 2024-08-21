import 'package:blue_wash_staff/model/task_model.dart';
import 'package:blue_wash_staff/services/TaskService.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;

  Future<void> getTAsk() async {
    var response = await TaskService().fetchTasks();
    if (response != null && response is List<TaskModel>) {
      return tasks.assignAll(response);
    } else {
      return tasks.assignAll([]);
    }
  }
}
