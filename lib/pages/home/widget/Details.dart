import 'dart:convert';
import 'dart:io';

import 'package:blue_wash_staff/config/config.dart';
import 'package:blue_wash_staff/model/phone_model.dart';
import 'package:blue_wash_staff/utils/color.dart';
import 'package:blue_wash_staff/widget/button.dart';
import 'package:blue_wash_staff/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:image/image.dart';

class DetailsPage extends StatefulWidget {
  final String carNumber;
  final String phone;
  const DetailsPage({super.key, required this.carNumber, required this.phone});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String ownerName = '';
  String carNumber = '';
  String address = '';
  String location = '';
  bool isLoading = true;
  LatLng? point;
  String? phone;
  XFile? _image1;
  XFile? _image2;
  XFile? _image3;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    print(widget.carNumber);
    var response = await http.post(
      Uri.parse("${config.base}${config.carData}"),
      body: jsonEncode({'car_number': widget.carNumber}),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 'success') {
      setState(() {
        ownerName = data['data']['owner'] ?? 'N/A';
        carNumber = data['data']['number'] ?? 'N/A';
        address = data['data']['address'] ?? 'N/A';
        location = data['data']['location'] ?? 'N/A';
        double lat = double.parse(data['data']['latitude']);
        double long = double.parse(data['data']['longitude']);

        point = LatLng(lat, long);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to fetch data')),
      );
    }
  }

  Future<void> _openGoogleMaps() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${point!.latitude},${point!.longitude}&travelmode=driving';
    if (await launchUrlString(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<XFile?> _compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    return result;
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final targetPath = directory.path + "/temp_${pickedFile.name}.jpg";
      final compressedImage =
          await _compressImage(File(pickedFile.path), targetPath);

      setState(() {
        if (compressedImage != null) {
          if (imageNumber == 1) {
            _image1 = compressedImage;
          } else if (imageNumber == 2) {
            _image2 = compressedImage;
          } else if (imageNumber == 3) {
            _image3 = compressedImage;
          }
        }
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Capture Images',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImagePickerButton(1, setState),
                  SizedBox(
                    height: 8,
                  ),
                  _buildImagePickerButton(2, setState),
                  SizedBox(
                    height: 8,
                  ),
                  _buildImagePickerButton(3, setState),
                  SizedBox(height: 20),
                  _image1 != null && _image2 != null && _image3 != null
                      ? ButtonBlue(
                          text: "Complete",
                          ontap: () {
                            Navigator.of(context).pop();
                            completed();
                          })
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //       completed();
                      //     },
                      //     child: Text('Complete'),
                      //   )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImagePickerButton(int imageNumber, StateSetter setStatee) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        _getImagePreview(imageNumber),
        IconButton(
            onPressed: () {
              _pickImage(imageNumber).then((_) {
                setStatee(
                    () {}); // Force the dialog to rebuild and show the picked image
              });
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.blue,
            ))
      ],
    );
  }

//_pickImage(imageNumber).then((_) {
  //   setStatee(
  //       () {}); // Force the dialog to rebuild and show the picked image
  // });
  Widget _getImagePreview(int imageNumber) {
    XFile? imageFile;
    if (imageNumber == 1) {
      imageFile = _image1;
    } else if (imageNumber == 2) {
      imageFile = _image2;
    } else if (imageNumber == 3) {
      imageFile = _image3;
    }

    return imageFile != null
        ? Image.file(
            File(imageFile.path),
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
        : Container(
            height: 150,
            width: 150,
            color: Colors.grey[300],
            child: Icon(Icons.camera_alt),
          );
  }

  Future<void> completed() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${config.base}${config.completedAdd}"),
    );
    request.fields['car_number'] = widget.carNumber;
    if (_image1 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('img1', _image1!.path));
    }
    if (_image2 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('img2', _image2!.path));
    }
    if (_image3 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('img3', _image3!.path));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var data = jsonDecode(responseData);

    if (data['status'] == 'success') {
      print(data);
      toaster().showsToast("${widget.carNumber} service has been Completed",
          Colors.green, Colors.white);
      Get.back();
    } else {
      toaster()
          .showsToast("Failed to complete service", Colors.red, Colors.white);
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Vehicle Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () {
              _showImagePickerDialog();
            },
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: AppColors.bbg),
              child: Center(
                child: Text(
                  "Completed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow2('Owner Name', ownerName, widget.phone),
                  const SizedBox(height: 15),
                  _buildDetailRow('Car Number', carNumber),
                  const SizedBox(height: 15),
                  _buildDetailRow('Address', address),
                  const SizedBox(height: 15),
                  Text(
                    "Location",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54),
                  ),
                  if (point != null)
                    Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: FlutterMap(
                            options: MapOptions(
                              zoom: 15,
                              center: point!,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                      point: point!,
                                      builder: (BuildContext context) {
                                        return Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                          size: 50,
                                        );
                                      }),
                                ],
                              ),
                            ])),
                  ButtonBlue(
                      text: "Get Direction",
                      ontap: () {
                        _openGoogleMaps();
                      })
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white30),
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 17),
        ),
      ],
    );
  }

  Widget _buildDetailRow2(String label, String value, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white30),
            ),
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    gradient: AppColors.bbg,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                    child: IconButton(
                        onPressed: () async {
                          String url = "tel:+91$phone";
                          if (await launchUrlString('tel:$phone')) {
                            await launch('tel:$phone');
                          } else {
                            throw 'Could not launch $phone';
                          }
                        },
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ))))
          ],
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 17),
        ),
      ],
    );
  }
}
