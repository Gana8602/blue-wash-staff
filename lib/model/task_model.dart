class TaskModel {
  String packageName;
  String date;
  String token;
  String staff_token;
  String service;
  String carNumber;

  TaskModel({
    required this.packageName,
    required this.date,
    required this.token,
    required this.staff_token,
    required this.service,
    required this.carNumber,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        packageName: json['package_name'],
        date: json['selected_date'],
        token: json['token'],
        staff_token: json['staff_token'],
        service: json['service'],
        carNumber: json['car_number']);
  }
}
