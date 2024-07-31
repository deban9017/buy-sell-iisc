// ignore_for_file: must_be_immutable

// import 'dart:io';

import 'package:buyandsell/auth/firebase_options.dart';
import 'package:buyandsell/widgets/imagepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:buyandsell/widgets/horiz_div.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:buyandsell/auth/firestorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemListingForm extends StatefulWidget {
  ItemListingForm({super.key, required this.mode});
  String mode;

  //Seller Data Fetched from Firebase___________________________________________
  String seller_name = '';
  String email = '';
  String uid = '';
  String wa_no = '';

  bool isStateSet = false;
  //Images______________________________________________________________________
  String? imagepath1;
  String? imagepath2;
  String? imagepath3;
  String? imagepath4;

  // File? image1;
  // File? image2;
  // File? image3;
  // File? image4;

  //Text Controllers____________________________________________________________
  TextEditingController categoryControl = TextEditingController();
  TextEditingController used_conditionControl = TextEditingController();
  TextEditingController used_forControl = TextEditingController();
  //email not required for controller
  //phone not required for controller
  //whatsapp not required for controller
  TextEditingController descriptionControl = TextEditingController();
  TextEditingController item_countControl = TextEditingController();
  TextEditingController item_nameControl = TextEditingController();
  TextEditingController locationControl = TextEditingController();
  TextEditingController negotiabilityControl = TextEditingController();
  //no controller for photo related fields
  TextEditingController cpControl = TextEditingController();
  TextEditingController other_priceControl = TextEditingController();
  TextEditingController other_storeControl = TextEditingController();
  TextEditingController spControl = TextEditingController();
  //no controller for seller name
  TextEditingController stateControl = TextEditingController();
  TextEditingController store_linkControl = TextEditingController();
  //no controller for time of listing
  //no controller for uid
//______________________________________________________________________________

  double sidePad = 20.0;
  double verticalPad = 10.0;
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
  late Color submitButtonColor;
  Color soldcolor = Color.fromARGB(255, 255, 87, 82);
  Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
  Color availablecolor = Color.fromARGB(255, 0, 201, 56);

  double borderRadius = 17.0;
  double focusBorderRadius = 15.0;
  double totalBorderRadius = 20.0;
  double focusBorderWidth = 2.0;
  double totalBorderWidth = 2.0;
  double buttonBorderRadius = 17.0;
  double buttonBorderWidth = 3.0;

  void getTheme() {
    if (mode == 'dark') {
      bgColor = Color.fromARGB(221, 13, 13, 40);
      textColor = Color.fromARGB(255, 255, 255, 255);
      focusColor = Color.fromARGB(255, 138, 181, 255);
      totalBorderColor = Color.fromARGB(255, 159, 199, 255);
      borderColor = Color.fromARGB(255, 85, 126, 183);
      buttonColor = Color.fromARGB(255, 255, 255, 255);
      buttonBorderColor = Color.fromARGB(255, 0, 189, 145);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 215, 215, 215);
      labelColor = Color.fromARGB(221, 24, 24, 58);
      dividerColor = Color.fromARGB(221, 37, 37, 82);
      hintTextColor = Color.fromARGB(255, 43, 43, 83);
      submitButtonColor = Color.fromARGB(255, 0, 127, 108);
    } else {
      bgColor = Color.fromARGB(255, 255, 255, 255);
      textColor = Color.fromARGB(255, 0, 13, 32);
      focusColor = Color.fromARGB(255, 44, 90, 171);
      totalBorderColor = Color.fromARGB(255, 0, 35, 83);
      borderColor = Color.fromARGB(255, 60, 101, 163);
      buttonColor = Color.fromARGB(255, 0, 0, 0);
      buttonBorderColor = Color.fromARGB(255, 0, 120, 92);
      buttonTextColor = Color.fromARGB(255, 0, 13, 32);
      iconColor = Color.fromARGB(255, 23, 23, 23);
      labelColor = Color.fromARGB(255, 227, 227, 227);
      dividerColor = Color.fromARGB(255, 160, 160, 160);
      hintTextColor = Color.fromARGB(255, 148, 148, 148);
      submitButtonColor = Color.fromARGB(255, 0, 156, 119);
    }
  }

  @override
  State<ItemListingForm> createState() => _ItemListingFormState();
}

class _ItemListingFormState extends State<ItemListingForm> {
  void onPressCancel(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Discard Changes?'),
            content: Text('Are you sure you want to discard the changes?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Discard'),
              ),
            ],
          );
        });
  }

  Future<void> setValues() async {
    //mode
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('mode');
    try {
      widget.mode = mode!;
    } catch (e) {
      widget.mode = 'dark';
    }

    if (FirebaseAuth.instance.currentUser != null) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ); //FIREBASE
      final database = FirebaseFirestore.instance; //FIREBASE
      database.settings = const Settings(
        persistenceEnabled: true,
      );
      CollectionReference studentCollection =
          await FirebaseFirestore.instance.collection('users');

      studentCollection.snapshots().listen((event) {
        event.docs.forEach((element) {
          // print('firebase uid ${FirebaseAuth.instance.currentUser!.uid}');
          // print('elem uid ${element['uid']}');

          if (element['uid'] == FirebaseAuth.instance.currentUser!.uid) {
            widget.seller_name = element['seller_name'];
            widget.email = element['email'];
            widget.uid = element['uid'];
            widget.wa_no = element['wa_no'];
            setState(() {
              print('data set');
              widget.isStateSet = true;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStateSet == false) {
      setValues();
    }
    widget.getTheme();

    //Functions for setting data________________________________________________
    int getused_condition(String condition) {
      if (condition == 'Brand new, unused') {
        return 5;
      } else if (condition == 'Like new, excellent') {
        return 4;
      } else if (condition == 'Good') {
        return 3;
      } else if (condition == 'Fair') {
        return 2;
      } else if (condition == 'Old but usable') {
        return 1;
      } else {
        return 0;
      }
    }

    int getAvailability(String availability) {
      availability = availability.toLowerCase();
      if (availability == 'sold') {
        return 2;
      } else if (availability == 'booked') {
        return 1;
      } else if (availability == 'available') {
        return 0;
      } else {
        return 2; //default sold i.e. not available
      }
    }

    bool getNegotiability(String negotiability) {
      negotiability = negotiability.toLowerCase();
      if (negotiability == 'negotiable') {
        return true;
      } else if (negotiability == 'non-negotiable') {
        return false;
      } else {
        return false;
      }
    }

    int getused_for(String used_for) {
      used_for = used_for.toLowerCase();
      if (used_for == 'used once or twice') {
        return -2;
      } else if (used_for == 'less than a week') {
        return -1;
      } else if (used_for == 'unused') {
        return 0;
      } else if (used_for == 'less than a month') {
        return 1;
      } else if (used_for == 'less than 2 months') {
        return 2;
      } else if (used_for == 'less than 3 months') {
        return 3;
      } else if (used_for == 'less than 6 months') {
        return 4;
      } else if (used_for == 'less than a year') {
        return 5;
      } else if (used_for == 'less than 2 years') {
        return 6;
      } else if (used_for == '3 years') {
        return 7;
      } else if (used_for == '4 years') {
        return 8;
      } else if (used_for == '5 years') {
        return 9;
      } else if (used_for == 'more than 5 years') {
        return 10;
      } else {
        return -3;
      }
    }

    //__________________________________________________________________________

    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.mode == 'dark'
            ? const Color.fromARGB(255, 3, 14, 34)
            : const Color.fromARGB(255, 245, 251, 255),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              weight: 200,
              size: 24.0,
              color: widget.mode == 'dark'
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color.fromARGB(255, 0, 8, 20),
            ),
            onPressed: () {
              onPressCancel(context);
            },
          ),
          backgroundColor: widget.mode == 'dark'
              ? const Color.fromARGB(255, 3, 14, 34)
              : const Color.fromARGB(255, 245, 251, 255),
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  onPressCancel(context);
                },
                icon: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 255, 0, 0)),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )),
          ],
          title: Text('Item Listing Form',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: widget.mode == 'dark'
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(255, 0, 8, 20),
                fontSize: 27.0,
                fontWeight: FontWeight.w800,
              )),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text('Seller Details',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: widget.verticalPad),
                              child: HorizontalDiv(
                                  dividerColor: widget.dividerColor,
                                  width: 10,
                                  span: 1,
                                  thickness: 1.0)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        enabled: false,
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: widget.labelColor,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                            ),
                            focusColor: widget.focusColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.focusColor,
                                  width: widget.focusBorderWidth),
                              borderRadius: BorderRadius.circular(
                                  widget.focusBorderRadius),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: BorderSide(
                                color: widget.borderColor,
                                width: 1.0,
                              ),
                            ),
                            labelText: FirebaseAuth.instance.currentUser!.email,
                            labelStyle: TextStyle(
                                color: widget.textColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            suffixIcon: Icon(
                              Icons.email,
                              color: widget.iconColor,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        enabled: false,
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: widget.labelColor,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                            ),
                            focusColor: widget.focusColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.focusColor,
                                  width: widget.focusBorderWidth),
                              borderRadius: BorderRadius.circular(
                                  widget.focusBorderRadius),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: BorderSide(
                                color: widget.borderColor,
                                width: 1.0,
                              ),
                            ),
                            labelText: widget.seller_name,
                            labelStyle: TextStyle(
                                color: widget.textColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            suffixIcon: Icon(
                              CupertinoIcons.person_fill,
                              color: widget.iconColor,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 10),
                              decoration: BoxDecoration(
                                  color: widget.labelColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text('+91',
                                  style: TextStyle(color: widget.textColor))),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.labelColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                  ),
                                  focusColor: widget.focusColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: widget.focusColor,
                                        width: widget.focusBorderWidth),
                                    borderRadius: BorderRadius.circular(
                                        widget.focusBorderRadius),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                    borderSide: BorderSide(
                                      color: widget.borderColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  labelText: widget.wa_no,
                                  labelStyle: TextStyle(
                                      color: widget.textColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400),
                                  suffixIcon: Icon(
                                    CupertinoIcons.phone_fill,
                                    color: widget.iconColor,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text('Item Details',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: widget.verticalPad),
                              child: HorizontalDiv(
                                  dividerColor: widget.dividerColor,
                                  width: 10,
                                  span: 1,
                                  thickness: 1.0)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.item_nameControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                          focusColor: widget.focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.focusColor,
                                width: widget.focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(widget.focusBorderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            borderSide: BorderSide(
                              color: widget.borderColor,
                              width: 1.0,
                            ),
                          ),
                          hintStyle: TextStyle(
                              color: widget.hintTextColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          hintText: 'Origin, Dan Brown',
                          labelText: 'Item Name*',
                          labelStyle: TextStyle(
                              color: widget.textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.locationControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                            ),
                            focusColor: widget.focusColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.focusColor,
                                  width: widget.focusBorderWidth),
                              borderRadius: BorderRadius.circular(
                                  widget.focusBorderRadius),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: BorderSide(
                                color: widget.borderColor,
                                width: 1.0,
                              ),
                            ),
                            hintStyle: TextStyle(
                                color: widget.hintTextColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            hintText: 'N block, Room-25',
                            labelText: 'Pickup Location*',
                            labelStyle: TextStyle(
                                color: widget.textColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            suffixIcon: Icon(
                              Icons.location_on_rounded,
                              color: widget.iconColor,
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 14),
                        //   child: Text('\u{20B9}',
                        //       style: TextStyle(
                        //         fontFamily: 'Nunito',
                        //         fontSize: 29,
                        //         fontWeight: FontWeight.w600,
                        //         color: widget.textColor,
                        //       )),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.spControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                focusColor: widget.focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.focusColor,
                                      width: widget.focusBorderWidth),
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                prefixText: '\u{20B9} ',
                                prefixStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                labelText: 'Selling Price*',
                                labelStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 19, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: widget.dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: widget.focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(widget.labelColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius))),
                              ),

                              width: 165,
                              controller: widget.categoryControl,

                              // hintText: 'books, decors etc.',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'books',
                                  label: 'Books',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'electronics',
                                  label: 'Electronics',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'decors',
                                  label: 'Decors',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'textile',
                                  label: 'Textile',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'cycle',
                                  label: 'Cycle',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'households',
                                  label: 'Households',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'sports',
                                  label: 'Sports',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'miscellaneous',
                                  label: 'Miscellaneous',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                              ],
                              label: Text('Category',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: widget.textColor)),
                              // onSelected: ,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: widget.focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(widget.bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius))),
                              ),

                              width: 174.2,
                              controller: widget.negotiabilityControl,

                              // hintText: 'Negotiablity',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'negotiable',
                                  label: 'Negotiable',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.availablecolor), //Green color
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'nonnegotiable',
                                  label: 'Non-Negotiable',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.soldcolor), //Red color
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                              ],
                              label: Text('Negotiablity',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: widget.textColor)),
                              // onSelected: ,
                            )),
                        Container(
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: 19, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: widget.dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: widget.focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(widget.bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius))),
                              ),

                              controller: widget.stateControl,
                              width: 166.2,
                              // hintText: 'Availability',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'sold',
                                  label: 'Sold',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.soldcolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'booked',
                                  label: 'Booked',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.bookedcolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'available',
                                  label: 'Available',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.availablecolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                              ],
                              label: Text('Availability*',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: widget.textColor)),
                              // onSelected: ,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text('Extra Details',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: widget.verticalPad),
                              child: HorizontalDiv(
                                  dividerColor: widget.dividerColor,
                                  width: 10,
                                  span: 1,
                                  thickness: 1.0)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: widget.focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(widget.bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius))),
                              ),
                              controller: widget.used_conditionControl,
                              width: 174.2,
                              // hintText: 'Condition',
                              // 5 for brand new, unused
                              // 4 for like new, excellent
                              // 3 for good
                              // 2 for fair
                              // 1 for old but usable
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: '5',
                                  label: 'Brand new, unused',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '4',
                                  label: 'Like new, excellent',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '3',
                                  label: 'Good',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '2',
                                  label: 'Fair',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '1',
                                  label: 'Old but usable',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                              ],
                              label: Text('Condition',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: widget.textColor)),
                              // onSelected: ,
                            )),
                        Container(
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: 19, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: widget.dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: widget.focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(widget.bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            widget.borderRadius))),
                              ),
                              controller: widget.used_forControl,

                              width: 166.2,
                              // hintText: 'Usage',
                              // for used_for: [usage]
                              // -2 used once or twice
                              // -1 for less than a week
                              // 0 for unused
                              // 1 for less than a month
                              // 2 for less than 2 months
                              // 3 for less than 3 months
                              // 4 for less than 6 months
                              // 5 for less than a year
                              // 6 for less than 2 years
                              // 7 for 3 years
                              // 8 for 4 years
                              // 9 for 5 years
                              // 10 for more than 5 years
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: '-2',
                                  label: 'Used once or twice',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '-1',
                                  label: 'Less than a week',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '0',
                                  label: 'Unused',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '1',
                                  label: 'Less than a month',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '2',
                                  label: 'Less than 2 months',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '3',
                                  label: 'Less than 3 months',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '4',
                                  label: 'Less than 6 months',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '5',
                                  label: 'Less than a year',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '6',
                                  label: 'Less than 2 years',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '7',
                                  label: '3 years',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '8',
                                  label: '4 years',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '9',
                                  label: '5 years',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: '10',
                                  label: 'More than 5 years',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: widget.textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.labelColor),
                                    foregroundColor: WidgetStateProperty.all(
                                        widget.textColor),
                                  ),
                                ),
                              ],
                              label: Text('Usage',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: widget.textColor)),
                              // onSelected: ,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.cpControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                focusColor: widget.focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.focusColor,
                                      width: widget.focusBorderWidth),
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                prefixStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                prefixText: '\u{20B9} ',
                                labelText: 'Cost Price',
                                labelStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: widget.dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.item_countControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                focusColor: widget.focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.focusColor,
                                      width: widget.focusBorderWidth),
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: widget.hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: '1',
                                labelText: 'Quantity',
                                labelStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.other_storeControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                focusColor: widget.focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.focusColor,
                                      width: widget.focusBorderWidth),
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: widget.hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: 'Amazon, Flipkart ...',
                                labelText: 'Other Store',
                                labelStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: widget.dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: widget.verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: widget.textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.other_priceControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                ),
                                focusColor: widget.focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: widget.focusColor,
                                      width: widget.focusBorderWidth),
                                  borderRadius: BorderRadius.circular(
                                      widget.focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      widget.borderRadius),
                                  borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: widget.hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                prefixText: '\u{20B9} ',
                                prefixStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: '230',
                                labelText: 'Store Price',
                                labelStyle: TextStyle(
                                    color: widget.textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.store_linkControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                          focusColor: widget.focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.focusColor,
                                width: widget.focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(widget.focusBorderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            borderSide: BorderSide(
                              color: widget.borderColor,
                              width: 1.0,
                            ),
                          ),
                          hintStyle: TextStyle(
                              color: widget.hintTextColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          hintText: 'eg : Amazon product link',
                          labelText: 'Store Link',
                          labelStyle: TextStyle(
                              color: widget.textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          // suffixIcon: Icon(
                          //   Icons.email,
                          //   color: widget.iconColor,
                          // )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: widget.verticalPad),
                      child: TextField(
                        maxLines: 5,
                        style: TextStyle(
                            color: widget.textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.descriptionControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                          focusColor: widget.focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.focusColor,
                                width: widget.focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(widget.focusBorderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            borderSide: BorderSide(
                              color: widget.borderColor,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                              color: widget.textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          // suffixIcon:
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text('Photos',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: widget.verticalPad),
                              child: HorizontalDiv(
                                  dividerColor: widget.dividerColor,
                                  width: 10,
                                  span: 1,
                                  thickness: 1.0)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PickImage(
                            mode: widget.mode,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            imageresult: (result) {
                              widget.imagepath1 = result;
                              setState(() {
                                print(
                                    'received path 1 _______${widget.imagepath1}');
                              });
                            }),
                        PickImage(
                            mode: widget.mode,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            imageresult: (result) {
                              widget.imagepath2 = result;
                              setState(() {
                                print(
                                    'received path 2_________${widget.imagepath2}');
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PickImage(
                            mode: widget.mode,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            imageresult: (result) {
                              widget.imagepath3 = result;
                              setState(() {
                                print(
                                    'received path 3________${widget.imagepath3}');
                              });
                            }),
                        PickImage(
                            mode: widget.mode,
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            imageresult: (result) {
                              widget.imagepath4 = result;
                              setState(() {
                                print(
                                    'received path 4______${widget.imagepath4}');
                              });
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              bool _doSubmit = true;
                              //Mandatory fields checkings
                              //Mandatory fields are item_name, location, sp, availability or state, and any one image
                              if (widget.item_nameControl.text.trim() == '' ||
                                  widget.locationControl.text.trim() == '' ||
                                  widget.spControl.text.trim() == '' ||
                                  widget.stateControl.text.trim() == '') {
                                //Show snackbar that mandatory fields are not filled
                                _doSubmit = false;
                                SnackBar snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Mandatory fields are not filled. Please fill them.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }
                              if (widget.imagepath1 == null &&
                                  widget.imagepath2 == null &&
                                  widget.imagepath3 == null &&
                                  widget.imagepath4 == null) {
                                //Show snackbar that at least one image is required
                                _doSubmit = false;
                                SnackBar snackBar = const SnackBar(
                                  backgroundColor: Colors.red,
                                  content:
                                      Text('At least one image is required.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              //Assigning values to variables
                              if (_doSubmit) {
                                //show loading dialog
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: widget.bgColor,
                                        title: Center(
                                          child: Text('Listing Your Item',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight:
                                                      widget.mode == 'dark'
                                                          ? FontWeight.w600
                                                          : FontWeight.w700,
                                                  color: widget.textColor,
                                                  fontFamily: 'Nunito')),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CircularProgressIndicator(
                                              color: widget.textColor,
                                              backgroundColor: widget.bgColor,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text('Please wait...',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        widget.mode == 'dark'
                                                            ? FontWeight.w600
                                                            : FontWeight.w700,
                                                    color: widget.textColor,
                                                    fontFamily: 'Nunito')),
                                          ],
                                        ),
                                      );
                                    });

                                String? _docId;
                                String category = widget.categoryControl.text ==
                                        ''
                                    ? 'miscellaneous'
                                    : widget.categoryControl.text.toLowerCase();
                                if (widget.categoryControl.text == '') {
                                  //show Snack bar that category set to miscellaneous
                                  SnackBar snackBar = const SnackBar(
                                    backgroundColor: Colors.red,
                                    content:
                                        Text('Category set to Miscellaneous'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                int used_condition = getused_condition(
                                    widget.used_conditionControl.text);
                                int used_for =
                                    getused_for(widget.used_forControl.text);
                                String email =
                                    FirebaseAuth.instance.currentUser!.email!;
                                String whatsapp = widget.wa_no;
                                String description =
                                    widget.descriptionControl.text.trim();
                                int item_count;
                                try {
                                  item_count = int.parse(
                                      widget.item_countControl.text.trim());
                                } catch (e) {
                                  item_count = 1;
                                }
                                String item_name =
                                    widget.item_nameControl.text.trim();
                                String location =
                                    widget.locationControl.text.trim();
                                bool negotiability = getNegotiability(
                                    widget.negotiabilityControl.text);
                                int sp;
                                try {
                                  if (widget.spControl.text.trim() == '') {
                                    sp = -1;
                                  }
                                  sp = int.parse(widget.spControl.text.trim());
                                  if (sp < 0) {
                                    sp = -1;
                                  }
                                } catch (e) {
                                  sp = -1;
                                }
                                int cp;
                                try {
                                  if (widget.cpControl.text.trim() == '') {
                                    cp = -1;
                                  }
                                  cp = int.parse(widget.cpControl.text.trim());
                                  if (cp < 0) {
                                    cp = -1;
                                  }
                                } catch (e) {
                                  cp = -1;
                                }
                                String other_store = widget
                                    .other_storeControl.text
                                    .trim()
                                    .toLowerCase();
                                int other_price;
                                try {
                                  if (widget.other_priceControl.text.trim() ==
                                      '') {
                                    other_price = -1;
                                  }
                                  other_price = int.parse(
                                      widget.other_priceControl.text.trim());
                                  if (other_price < 0) {
                                    other_price = -1;
                                  }
                                } catch (e) {
                                  other_price = -1;
                                }
                                String seller_name = widget.seller_name;
                                int state =
                                    getAvailability(widget.stateControl.text);
                                String store_link =
                                    widget.store_linkControl.text;
                                String uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                String photo1url = '';
                                String photo2url = '';
                                String photo3url = '';
                                String photo4url = '';

                                await Firebase.initializeApp(
                                  options:
                                      DefaultFirebaseOptions.currentPlatform,
                                ); //FIREBASE
                                final database =
                                    FirebaseFirestore.instance; //FIREBASE
                                database.settings = const Settings(
                                  persistenceEnabled: true,
                                );
                                CollectionReference itemCollection =
                                    await FirebaseFirestore.instance
                                        .collection('itemlisting');

                                await itemCollection.add({
                                  'category': category,
                                  'condition': {
                                    'used_condition': used_condition,
                                    'used_for': used_for,
                                  },
                                  'contact_details': {
                                    'email': email,
                                    'whatsapp': whatsapp,
                                  },
                                  'description': description,
                                  'item_count': item_count,
                                  'item_name': item_name,
                                  'location': location,
                                  'negotiability': negotiability,
                                  'price': {
                                    'sp': sp,
                                    'cp': cp,
                                    'other_store': other_store,
                                    'other_price': other_price,
                                  },
                                  'seller_name': seller_name,
                                  'state': state,
                                  'store_link': store_link,
                                  'uid': uid,
                                  'time_of_listing': DateTime.now().toString(),
                                  'photo1url': photo1url,
                                  'photo2url': photo2url,
                                  'photo3url': photo3url,
                                  'photo4url': photo4url,
                                }).then((value) async {
                                  _docId = value.id;
                                  //Uploading 4 images

                                  final storageService = StorageService();
                                  if (widget.imagepath1 != null) {
                                    String imagename =
                                        '${FirebaseAuth.instance.currentUser!.uid}/$_docId/image1';
                                    await storageService.uploadImage(
                                        imagename, widget.imagepath1!);
                                    String? temp = await storageService
                                        .downloadURL(imagename);
                                    photo1url = temp == null ? '' : temp;
                                  }
                                  if (widget.imagepath2 != null) {
                                    String imagename =
                                        '${FirebaseAuth.instance.currentUser!.uid}/$_docId/image2';
                                    await storageService.uploadImage(
                                        imagename, widget.imagepath2!);
                                    String? temp = await storageService
                                        .downloadURL(imagename);
                                    photo2url = temp == null ? '' : temp;
                                  }
                                  if (widget.imagepath3 != null) {
                                    String imagename =
                                        '${FirebaseAuth.instance.currentUser!.uid}/$_docId/image3';
                                    await storageService.uploadImage(
                                        imagename, widget.imagepath3!);
                                    String? temp = await storageService
                                        .downloadURL(imagename);
                                    photo3url = temp == null ? '' : temp;
                                  }
                                  if (widget.imagepath4 != null) {
                                    String imagename =
                                        '${FirebaseAuth.instance.currentUser!.uid}/$_docId/image4';
                                    await storageService.uploadImage(
                                        imagename, widget.imagepath4!);
                                    String? temp = await storageService
                                        .downloadURL(imagename);
                                    photo4url = temp == null ? '' : temp;
                                  }

                                  itemCollection.doc(_docId).update({
                                    'photo1url': photo1url,
                                    'photo2url': photo2url,
                                    'photo3url': photo3url,
                                    'photo4url': photo4url,
                                  });

                                  //Adding item to itemstack
                                  //Open itemstack document and add this item's id to it
                                  final itemstackCollection = FirebaseFirestore
                                      .instance
                                      .collection('itemstack');
                                  final itemstackDoc = await itemstackCollection
                                      .doc('stack')
                                      .get();
                                  //stack has a field called data which is a list of maps {id: itemid, timestamp: time}
                                  List<dynamic> data = itemstackDoc['data'];
                                  data.add({
                                    'id': _docId,
                                    'timestamp': DateTime.now().toString()
                                  });
                                  await itemstackCollection
                                      .doc('stack')
                                      .update({'data': data});

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 13),
                              decoration: BoxDecoration(
                                color: widget.submitButtonColor,
                                border: Border.all(
                                  color: widget.buttonBorderColor,
                                  width: widget.buttonBorderWidth,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 21,
                                    fontWeight: widget.mode == 'dark'
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
