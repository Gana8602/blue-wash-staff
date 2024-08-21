import 'package:blue_wash_staff/pages/profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';
import 'widget/completed.dart';
import 'widget/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          "SERVICES",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: AppColors.bbg),
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.person_2_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => ProfilePage());
                },
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.black,
              child: TabBar(
                  dividerColor: Colors.black,
                  indicatorWeight: 2.0,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: AppColors.Tcolor,
                  controller: _controller,
                  tabs: [
                    Text(
                      "Task List",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Completed",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                  controller: _controller, children: [TaskList(), Completed()]),
            ),
          ],
        ),
      ),
    );
  }
}
