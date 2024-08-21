import 'dart:convert';

import 'package:blue_wash_staff/config/Data.dart';
import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/controller/taskController.dart';
import 'package:blue_wash_staff/model/task_model.dart';
import 'package:blue_wash_staff/pages/home/widget/Details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../utils/color.dart';
import 'package:latlong2/latlong.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskController _task = Get.put(TaskController());
  List<LatLng>? listPOints;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _task.getTAsk();
  }

  Future<void> getPhone(String token, String carNumber) async {
    var response = await http.post(Uri.parse("${config.base}${config.phone}"),
        body: jsonEncode({"token": token}));
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      String ph = data['phone_number'];
      print(ph);
      Get.to(() => DetailsPage(
            carNumber: carNumber,
            phone: ph,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        List<TaskModel> list = _task.tasks;
        if (list.isEmpty) {
          return Center(
              child: Text(
            "No Task Assigned yet",
            style: TextStyle(color: Colors.white),
          ));
        }
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    getPhone(list[index].token, list[index].carNumber);
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: AppColors.bNcolor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pending Task",
                            style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            list[index].date,
                            style: GoogleFonts.montserrat(
                              color: AppColors.DTcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Service : ${list[index].service}/08",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                list[index].packageName,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
