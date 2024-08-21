import 'dart:convert';

import 'package:blue_wash_staff/config/Data.dart';
import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/model/completedModel.dart';
import 'package:http/http.dart' as http;

class CompletedService {
  Future<dynamic> fetchCompleted() async {
    var response = await http.post(
      Uri.parse("${config.base}${config.completeds}"),
      body: jsonEncode({'staff_token': Data.token}),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<CompletedModel> completed =
          list.map((e) => CompletedModel.fromJson(e)).toList();

      return completed;
    } else {
      return null;
    }
  }
}
