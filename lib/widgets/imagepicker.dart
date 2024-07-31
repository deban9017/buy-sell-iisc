// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  PickImage(
      {super.key,
      required this.mode,
      required this.width,
      required this.imageresult});
  String mode = 'dark'; // dark or light
  double width;
  Function(String? result) imageresult;
  String? resultImgPath;
  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _image;
  final picker = ImagePicker();

//IMAGE PICKER__________________________________________________________________
  Future getImage(String source) async {
    final pickedImage = await picker.pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if (_image != null) {
      widget.resultImgPath = 'previous path changed';
      print(widget.resultImgPath);
      print('Image was not null');
    }

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        // print(_image);

        widget.imageresult(pickedImage.path);
      } else {
        widget.imageresult(null);
      }
    });
  }

//THEME_________________________________________________________________________
  late Color bgColor;
  late Color textColor;
  late Color focusColor;
  late Color borderColor;
  late Color totalBorderColor;
  late Color buttonColor;
  late Color buttonTextColor;
  late Color buttonBorderColor;
  late Color iconColor;
  late Color labelColor;
  late Color dividerColor;
  late Color hintTextColor;
  Color soldcolor = Color.fromARGB(255, 255, 87, 82);
  Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
  Color availablecolor = Color.fromARGB(255, 0, 201, 56);

  double borderRadius = 17.0;
  double focusBorderRadius = 15.0;
  double totalBorderRadius = 20.0;
  double focusBorderWidth = 2.0;
  double totalBorderWidth = 2.0;
  double buttonBorderRadius = 17.0;
  double buttonBorderWidth = 2.0;

  void getTheme() {
    if (widget.mode == 'dark') {
      bgColor = Color.fromARGB(221, 13, 13, 40);
      textColor = Color.fromARGB(255, 255, 255, 255);
      focusColor = Color.fromARGB(255, 138, 181, 255);
      totalBorderColor = Color.fromARGB(255, 159, 199, 255);
      borderColor = Color.fromARGB(255, 85, 126, 183);
      buttonColor = Color.fromARGB(255, 255, 255, 255);
      buttonBorderColor = Color.fromARGB(255, 0, 255, 195);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 54, 54, 98);
      labelColor = Color.fromARGB(221, 24, 24, 58);
      dividerColor = Color.fromARGB(221, 37, 37, 82);
      hintTextColor = Color.fromARGB(255, 43, 43, 83);
    } else {
      bgColor = Color.fromARGB(255, 255, 255, 255);
      textColor = Color.fromARGB(255, 0, 13, 32);
      focusColor = Color.fromARGB(255, 44, 90, 171);
      totalBorderColor = Color.fromARGB(255, 0, 35, 83);
      borderColor = Color.fromARGB(255, 201, 216, 228);
      buttonColor = Color.fromARGB(255, 0, 0, 0);
      buttonBorderColor = Color.fromARGB(255, 0, 120, 92);
      buttonTextColor = Color.fromARGB(255, 0, 13, 32);
      iconColor = Color.fromARGB(255, 136, 162, 194);
      labelColor = Color.fromARGB(255, 227, 237, 245);
      dividerColor = Color.fromARGB(255, 160, 160, 160);
      hintTextColor = Color.fromARGB(255, 148, 148, 148);
    }
  }
//______________________________________________________________________________

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Center(
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.width,
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(buttonBorderRadius),
              border: Border.all(
                color: borderColor,
                width: buttonBorderWidth,
              ),
            ),
            child: Icon(
              Icons.add_rounded,
              color: iconColor,
              size: widget.width * 0.5,
            ),
          ),
          _image == null
              ? Container()
              : SizedBox(
                  width: widget.width,
                  height: widget.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                      child: Image.file(_image!, fit: BoxFit.fitWidth)),
                ),
          SizedBox(
            width: widget.width,
            height: widget.width,
            child: InkWell(
              onTap: () {
                showBarModalBottomSheet(
                    backgroundColor: bgColor,
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  getImage('camera');
                                },
                                child: Card(
                                  color: labelColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: iconColor,
                                      size: MediaQuery.of(context).size.width *
                                          0.125,
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    getImage('gallery');
                                  },
                                  child: Card(
                                    color: labelColor,
                                    child: Center(
                                      child: Icon(
                                        Icons.photo,
                                        color: iconColor,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.125,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
