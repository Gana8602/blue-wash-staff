import 'dart:convert';

import 'package:blue_wash_staff/config/Data.dart';
import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/pages/home/home.dart';
import 'package:blue_wash_staff/widget/button.dart';
import 'package:blue_wash_staff/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _username,
              style: TextStyle(color: Colors.white),
              // keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  counterText: '',
                  // prefixText: '+91  ',
                  label: Text(
                    'Enter Your Username',
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  hintText: 'Enter Username here',
                  hintStyle: GoogleFonts.montserrat(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _password,
              style: TextStyle(color: Colors.white),
              // keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  counterText: '',
                  // prefixText: '+91  ',
                  label: Text(
                    'Enter Your Password',
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  hintText: 'Enter Password here',
                  hintStyle: GoogleFonts.montserrat(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            ButtonBlue(
                text: "Login",
                ontap: () {
                  login();
                })
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    var response = await http.post(Uri.parse("${config.base}${config.login}"),
        body: jsonEncode(
            {'username': _username.text, 'password': _password.text}));
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      print(data);
      setState(() {
        Data.token = data['token'];
        Data.name = data['name'];
        Data.username = data['username'];
        Data.email = data['email'];
        Data.phone = data['phone_number'];
        Data.image = data['image'];
      });
      print(Data.token);
      Get.to(() => HomePage());
    } else {
      toaster().showsToast(data['error'], Colors.red, Colors.white);
    }
  }
}


//a950166ccd652897664b7d2a1be833b8