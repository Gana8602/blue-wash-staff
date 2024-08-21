import 'package:blue_wash_staff/controller/completedController.dart';
import 'package:blue_wash_staff/model/completedModel.dart';
import 'package:blue_wash_staff/services/Completed_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  final CompletedController _complete = Get.put(CompletedController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _complete.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        List<CompletedModel> list = _complete.completeds;
        if (list.isEmpty) {
          return Center(
              child: Text(
            "No Completeds yet",
            style: TextStyle(color: Colors.white),
          ));
        }
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  // onTap: () {
                  //   Get.to(() => DetailsPage(carNumber: list[index].carNumber));
                  // },
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
                            "Completed Task",
                            style: GoogleFonts.montserrat(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            list[index].completed_date,
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
