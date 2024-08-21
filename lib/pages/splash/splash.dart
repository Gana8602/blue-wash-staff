import 'package:blue_wash_staff/pages/auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> nav() async {
    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      Get.to(() => LoginPage());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/splash.png"), fit: BoxFit.cover)),
      ),
    );
  }
}
