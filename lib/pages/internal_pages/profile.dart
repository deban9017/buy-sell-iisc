// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:buyandsell/auth/firebase_options.dart';
import 'package:buyandsell/widgets/horiz_div.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.mode});
  final String mode;

  bool editingNow = false;
  bool isStateSet = false;

  String docId = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController uidController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController waController = TextEditingController();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //Variables________________________________________________________________

    //__________________________________________________________________________

    // late Color bgColor;
    late Color textColor;
    late Color focusColor;
    late Color borderColor;
    // late Color buttonColor;
    // late Color buttonTextColor;
    late Color buttonBorderColor;
    late Color iconColor;
    late Color labelColor;
    late Color dividerColor;
    // late Color hintTextColor;
    // late Color submitButtonColor;
    Color soldcolor = Color.fromARGB(255, 255, 87, 82);
    // Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
    // Color availablecolor = Color.fromARGB(255, 0, 201, 56);

    double borderRadius = 17.0;
    double focusBorderRadius = 15.0;
    // double totalBorderRadius = 20.0;
    double focusBorderWidth = 2.0;
    // double totalBorderWidth = 2.0;
    double buttonBorderRadius = 17.0;
    double buttonBorderWidth = 2.0;

    void getTheme() {
      if (widget.mode == 'dark') {
        // bgColor = Color.fromARGB(221, 13, 13, 40);
        textColor = Color.fromARGB(255, 255, 255, 255);
        focusColor = Color.fromARGB(255, 138, 181, 255);
        borderColor = Color.fromARGB(255, 85, 126, 183);
        // buttonColor = Color.fromARGB(255, 255, 255, 255);
        buttonBorderColor = Color.fromARGB(255, 0, 189, 145);
        // buttonTextColor = Color.fromARGB(255, 255, 255, 255);
        iconColor = Color.fromARGB(255, 215, 215, 215);
        labelColor = Color.fromARGB(255, 25, 25, 61);
        dividerColor = Color.fromARGB(221, 37, 37, 82);
        // hintTextColor = Color.fromARGB(255, 43, 43, 83);
        // submitButtonColor = Color.fromARGB(255, 0, 127, 108);
      } else {
        // bgColor = Color.fromARGB(255, 255, 255, 255);
        textColor = Color.fromARGB(255, 0, 13, 32);
        focusColor = Color.fromARGB(255, 44, 90, 171);
        borderColor = Color.fromARGB(255, 60, 101, 163);
        // buttonColor = Color.fromARGB(255, 0, 0, 0);
        buttonBorderColor = Color.fromARGB(255, 0, 70, 54);
        // buttonTextColor = Color.fromARGB(255, 0, 13, 32);
        iconColor = Color.fromARGB(255, 23, 23, 23);
        labelColor = Color.fromARGB(255, 226, 251, 255);
        dividerColor = Color.fromARGB(255, 160, 160, 160);
        // hintTextColor = Color.fromARGB(255, 148, 148, 148);
        // submitButtonColor = Color.fromARGB(255, 0, 156, 119);
      }
    }

    bool validateWa(String wa) {
      if (wa.length == 10) {
        for (int i = 0; i < wa.length; i++) {
          if (!'0123456789'.contains(wa[i])) {
            return false;
          }
        }
        return true;
      }
      return false;
    }

    Future<void> setValues() async {
      widget.emailController.text = FirebaseAuth.instance.currentUser!.email!;
      widget.uidController.text = FirebaseAuth.instance.currentUser!.uid;
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ); //FIREBASE
      final database = FirebaseFirestore.instance; //FIREBASE
      database.settings = const Settings(
        persistenceEnabled: true,
      );
      CollectionReference users =
          await FirebaseFirestore.instance.collection('users');

      //Find the doc with uid == FirebaseAuth.instance.currentUser!.uid
      final QuerySnapshot result = await users
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      //Store seller_name and wa_no in controllers
      widget.nameController.text = result.docs[0]['seller_name'];
      widget.waController.text = result.docs[0]['wa_no'];
      widget.docId = result.docs[0].id;
      setState(() {
        widget.isStateSet = true;
      });
    }

    //__________________________________________________________________________

    getTheme();
    if (!widget.isStateSet) {
      setValues();
    }

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
              Navigator.pop(context);
            },
          ),
          backgroundColor: widget.mode == 'dark'
              ? const Color.fromARGB(255, 3, 14, 34)
              : const Color.fromARGB(255, 245, 251, 255),
          elevation: 0.0,
          actions: [
            widget.editingNow
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextButton(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: widget.mode == 'dark'
                              ? FontWeight.w500
                              : FontWeight.w600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      onPressed: () {
                        //Update the user's name and wa_no in the database
                        if (widget.nameController.text.isNotEmpty) {
                          if (validateWa(widget.waController.text)) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.docId)
                                .update({
                              'seller_name': widget.nameController.text,
                              'wa_no': widget.waController.text,
                            });
                            setState(() {
                              widget.editingNow = false;
                            });
                          }
                        }
                      },
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        widget.editingNow = true;
                      });
                    },
                    icon: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )),
          ],
          title: Text('Profile',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: widget.mode == 'dark'
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(255, 0, 8, 20),
                fontSize: 27.0,
                fontWeight: FontWeight.w800,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  controller: widget.emailController,
                  enabled: false,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: labelColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0,
                        ),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400),
                      suffixIcon: Icon(
                        widget.mode == 'dark'
                            ? Icons.email
                            : Icons.email_outlined,
                        color: iconColor,
                      )),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: TextField(
                        controller: widget.uidController,
                        enabled: false,
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: labelColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          focusColor: focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: focusColor, width: focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(focusBorderRadius),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'UID',
                          labelStyle: TextStyle(
                              color: textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.uidController.text));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(milliseconds: 500),
                      ));
                    },
                    color: buttonBorderColor,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  controller: widget.nameController,
                  enabled: widget.editingNow,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: labelColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0,
                        ),
                      ),
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400),
                      suffixIcon: Icon(
                        widget.mode == 'dark'
                            ? Icons.person
                            : Icons.person_outline_outlined,
                        color: iconColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextField(
                  controller: widget.waController,
                  enabled: widget.editingNow,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: labelColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0,
                        ),
                      ),
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400),
                      labelText: 'Whatsapp',
                      labelStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400),
                      suffixIcon: Icon(
                        Icons.phone,
                        color: iconColor,
                      )),
                ),
              ),
              Expanded(child: Container()),
              HorizontalDiv(
                  dividerColor: dividerColor,
                  width: 30,
                  span: .96,
                  thickness: 1),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: FirebaseAuth.instance.currentUser!.email!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color.fromARGB(255, 0, 151, 43),
                        content: Text('Password reset email sent'),
                        duration: Duration(milliseconds: 1100),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: labelColor,
                        borderRadius: BorderRadius.circular(buttonBorderRadius),
                        border: Border.all(
                          color: buttonBorderColor,
                          width: buttonBorderWidth,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key_rounded, color: iconColor),
                          const SizedBox(width: 15),
                          Text(
                            'Change Password',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20.0,
                              fontFamily: 'Nunito',
                              fontWeight: widget.mode == 'dark'
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      FirebaseAuth.instance.signOut();
                      //remove all screens from stack and push Wrapper
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: soldcolor,
                        borderRadius: BorderRadius.circular(buttonBorderRadius),
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 43, 35),
                          width: buttonBorderWidth,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: iconColor),
                          const SizedBox(width: 15),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20.0,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
