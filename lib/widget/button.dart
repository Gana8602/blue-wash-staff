import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color.dart';

class ButtonBlue extends StatelessWidget {
  final String text;
  final void Function()? ontap;
  const ButtonBlue({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 80,
        // color: Colors.amber,
        child: Center(
          child: Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(
                gradient: AppColors.bbg,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    ">",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ">",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ">",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ">",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
