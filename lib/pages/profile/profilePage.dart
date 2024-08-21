import 'dart:convert';
import 'dart:io';

import 'package:blue_wash_staff/config/Data.dart';
import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/widget/button.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../utils/color.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/back.png",
              ),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                        image: DecorationImage(
                            image:
                                NetworkImage("${config.base}${Data.image}"))),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: InkWell(
                            onTap: _SShowDialog,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                gradient: AppColors.bbg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 300,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  gradient: LinearGradient(colors: [
                    Colors.white70.withOpacity(0.2),
                    Colors.grey.withOpacity(0.3)
                  ])),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "User name",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Phone number",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Email Id",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          ":   ${Data.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          ":   ${Data.username}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          ":   ${Data.phone}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          ":   ${Data.email}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> profileChange() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${config.base}${config.imageChange}"),
    );
    request.fields['token'] = Data.token;

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        setState(() {
          isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image added successfully')),
        );
        var data = jsonDecode(responseBody);

        setState(() {
          Data.token = data['user']['token'];
          Data.name = data['user']['name'];
          Data.username = data['user']['username'];
          Data.email = data['user']['email'];
          Data.phone = data['user']['phone_number'];
          Data.image = data['user']['image'];
          isLoading = false;
          _image = null;
        });

        Get.back();
        //uploads\/667eb3b8a6f67.jpg
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add Image')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: result.files.single.path!,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ]);

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    }
  }

  void _SShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                height: 300,
                width: 300,
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: [4, 4],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: _image != null
                            ? Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  image: DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  await _pickImage();
                                  setState(() {});
                                },
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    image: DecorationImage(
                                      image: AssetImage("assets/place.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          profileChange();
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              gradient: AppColors.bbg),
                          child: Center(
                            child: Text(
                              "Save",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                      // TextButton(
                      //   onPressed: () {
                      //     // Handle save action if needed
                      //     profileChange();
                      //   },
                      //   child: Text(
                      //     "Save",
                      //     style: GoogleFonts.montserrat(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
