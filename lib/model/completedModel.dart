import 'package:blue_wash_staff/pages/home/widget/completed.dart';

class CompletedModel {
  int id;
  String packageName;
  String completed_date;
  String token;
  String staff_token;
  String service;
  String car_Number;

  CompletedModel({
    required this.id,
    required this.packageName,
    required this.completed_date,
    required this.token,
    required this.staff_token,
    required this.service,
    required this.car_Number,
  });

  factory CompletedModel.fromJson(Map<String, dynamic> json) {
    return CompletedModel(
        id: json['id'],
        packageName: json['package_name'],
        completed_date: json['completed_date'],
        token: json['token'],
        staff_token: json['staff_token'],
        service: json['service'],
        car_Number: json['car_number']);
  }
}
