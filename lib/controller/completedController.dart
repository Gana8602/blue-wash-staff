import 'package:blue_wash_staff/model/completedModel.dart';
import 'package:blue_wash_staff/services/Completed_service.dart';
import 'package:get/get.dart';

class CompletedController extends GetxController {
  var completeds = <CompletedModel>[].obs;

  Future<void> fetchData() async {
    var response = await CompletedService().fetchCompleted();
    if (response != null && response is List<CompletedModel>) {
      completeds.assignAll(response);
    } else {
      completeds.assignAll([]);
    }
  }
}
