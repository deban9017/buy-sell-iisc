// ignore_for_file: must_be_immutable

import 'package:buyandsell/auth/firebase_options.dart';
import 'package:buyandsell/functions/homedataclass.dart';
import 'package:buyandsell/pages/internal_pages/all_items.dart';
import 'package:buyandsell/pages/internal_pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Options extends StatefulWidget {
  Options({super.key, required this.mode});
  String mode;

  Map fetchedData = {};
  Homedataclass result = Homedataclass(data: {});
  List dataList = [];
  List finalDataList = [];

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    //Functions_________________________________________________________________

    void getMode() async {
      final prefs = await SharedPreferences.getInstance();
      final mode = prefs.getString('mode');
      try {
        widget.mode = mode!;
      } catch (e) {
        widget.mode = 'dark';
      }
    }

    //__________________________________________________________________________

    late Color bgColor;
    late Color textColor;
    // late Color focusColor;
    // late Color borderColor;
    // late Color totalBorderColor;
    // late Color buttonColor;
    // late Color buttonTextColor;
    late Color buttonBorderColor;
    late Color iconColor;
    late Color labelColor;
    // late Color dividerColor;
    // late Color hintTextColor;
    // late Color submitButtonColor;


    double buttonBorderRadius = 17.0;
    double buttonBorderWidth = 2.0;

    void getTheme() {
      if (widget.mode == 'dark') {
        bgColor = Color.fromARGB(221, 13, 13, 40);
        textColor = Color.fromARGB(255, 255, 255, 255);
        // focusColor = Color.fromARGB(255, 138, 181, 255);
        // totalBorderColor = Color.fromARGB(255, 159, 199, 255);
        // borderColor = Color.fromARGB(255, 85, 126, 183);
        // buttonColor = Color.fromARGB(255, 255, 255, 255);
        buttonBorderColor = Color.fromARGB(255, 0, 189, 145);
        // buttonTextColor = Color.fromARGB(255, 255, 255, 255);
        iconColor = Color.fromARGB(255, 215, 215, 215);
        labelColor = Color.fromARGB(255, 25, 25, 61);
        // dividerColor = Color.fromARGB(221, 37, 37, 82);
        // hintTextColor = Color.fromARGB(255, 43, 43, 83);
        // submitButtonColor = Color.fromARGB(255, 0, 127, 108);
      } else {
        bgColor = Color.fromARGB(255, 255, 255, 255);
        textColor = Color.fromARGB(255, 0, 13, 32);
        // focusColor = Color.fromARGB(255, 44, 90, 171);
        // totalBorderColor = Color.fromARGB(255, 0, 35, 83);
        // borderColor = Color.fromARGB(255, 60, 101, 163);
        // buttonColor = Color.fromARGB(255, 0, 0, 0);
        buttonBorderColor = Color.fromARGB(255, 0, 70, 54);
        // buttonTextColor = Color.fromARGB(255, 0, 13, 32);
        iconColor = Color.fromARGB(255, 23, 23, 23);
        labelColor = Color.fromARGB(255, 226, 251, 255);
        // dividerColor = Color.fromARGB(255, 160, 160, 160);
        // hintTextColor = Color.fromARGB(255, 148, 148, 148);
        // submitButtonColor = Color.fromARGB(255, 0, 156, 119);
      }
    }

    SizedBox sizedBox = const SizedBox(height: 15);

    //__________________________________________________________________________

    getMode();
    getTheme();

    return SafeArea(
        child: Scaffold(
      backgroundColor: widget.mode == 'dark'
          ? const Color.fromARGB(255, 3, 14, 34)
          : const Color.fromARGB(255, 245, 251, 255),
      appBar: AppBar(
        leading: Container(
          child: SvgPicture.asset(
            'lib/Assets/Images/logo.svg',
            colorFilter: ColorFilter.mode(
                widget.mode == 'dark'
                    ? const Color.fromARGB(255, 248, 248, 248)
                    : const Color.fromARGB(255, 4, 14, 30),
                BlendMode.srcIn),
          ),
        ),
        backgroundColor: widget.mode == 'dark'
            ? const Color.fromARGB(255, 3, 14, 34)
            : const Color.fromARGB(255, 245, 251, 255),
        title: Text('Buy and Sell',
            style: TextStyle(
                fontFamily: 'Nunito',
                color: widget.mode == 'dark'
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 0, 8, 20),
                fontSize: 27.0,
                fontWeight: FontWeight.w800)),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Profile(mode: widget.mode);
                    }));
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
                      children: [
                        Icon(Icons.person_outline_outlined, color: iconColor),
                        const SizedBox(width: 15),
                        Text(
                          'Profile',
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
            sizedBox,
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    Map data = {};
                    if (FirebaseAuth.instance.currentUser != null) {
                      await Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      ); //FIREBASE
                      final database = FirebaseFirestore.instance; //FIREBASE
                      database.settings = const Settings(
                        persistenceEnabled: true,
                      );
                      CollectionReference studentCollection =
                          await FirebaseFirestore.instance
                              .collection('itemlisting');

                      studentCollection.snapshots().listen((event) {
                        event.docs.forEach((element) {
                          data[element.id] = element.data();
                        });
                        // widget.dataLoaded = true;

                        widget.fetchedData = data;
                        widget.result = Homedataclass(data: widget.fetchedData);

                        widget.dataList =
                            widget.result.maptoList(widget.result.data);

                        String _email =
                            FirebaseAuth.instance.currentUser!.email!;
                        //finalDataList will contain the items which has email: _email
                        widget.finalDataList = widget.dataList
                            .where((element) =>
                                element['contact_details']['email'] == _email)
                            .toList();

                        print(widget.dataList.length);
                        print(widget.finalDataList.length);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllItems(
                              heading: 'Your Items',
                              category: 'all',
                              mode: widget.mode,
                              dataList: widget.finalDataList);
                        }));
                      });
                    }
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
                      children: [
                        Icon(Icons.category_outlined, color: iconColor),
                        const SizedBox(width: 15),
                        Text(
                          'Your Items',
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
            sizedBox,
            // Row(
            //   children: [
            //     Expanded(
            //         child: InkWell(
            //       onTap: () {},
            //       child: Container(
            //         padding: const EdgeInsets.all(15),
            //         decoration: BoxDecoration(
            //           color: labelColor,
            //           borderRadius: BorderRadius.circular(buttonBorderRadius),
            //           border: Border.all(
            //             color: buttonBorderColor,
            //             width: buttonBorderWidth,
            //           ),
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(Icons.favorite_outline_rounded, color: iconColor),
            //             SizedBox(width: 15),
            //             Text(
            //               'Favourites',
            //               style: TextStyle(
            //                 color: textColor,
            //                 fontSize: 20.0,
            //                 fontFamily: 'Nunito',
            //                 fontWeight: widget.mode == 'dark'
            //                     ? FontWeight.w600
            //                     : FontWeight.w700,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )),
            //   ],
            // ),
            // sizedBox,
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    if (widget.mode == 'dark') {
                      prefs.setString('mode', 'light');
                      setState(() {
                        widget.mode = 'light';
                      });
                    } else {
                      prefs.setString('mode', 'dark');
                      setState(() {
                        widget.mode = 'dark';
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: labelColor,
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                      border: Border.all(
                        color: buttonBorderColor,
                        width: buttonBorderWidth,
                      ),
                    ),
                    child: Row(
                      children: [
                        widget.mode == 'dark'
                            ? Icon(Icons.light_mode_outlined, color: iconColor)
                            : Icon(Icons.dark_mode_outlined, color: iconColor),
                        SizedBox(width: 15),
                        Text(
                          widget.mode == 'dark'
                              ? 'Change to Light Mode'
                              : 'Change to Dark Mode',
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
            sizedBox,
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: bgColor,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 15),
                                Center(
                                  child: Text('Made with ❤️ by Deban',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 22.0,
                                          fontFamily: 'Nunito',
                                          fontWeight: widget.mode == 'dark'
                                              ? FontWeight.w500
                                              : FontWeight.w600)),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Center(
                                    child: Text('Close',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 20.0,
                                            fontFamily: 'Nunito',
                                            fontWeight: widget.mode == 'dark'
                                                ? FontWeight.w600
                                                : FontWeight.w700))),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: labelColor,
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                      border: Border.all(
                        color: buttonBorderColor,
                        width: buttonBorderWidth,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: iconColor),
                        const SizedBox(width: 15),
                        Text(
                          'About App',
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        padding: EdgeInsets.zero,
        height: MediaQuery.of(context).size.height * 0.075,
        color: widget.mode == 'dark'
            ? const Color.fromARGB(255, 3, 14, 34)
            : const Color.fromARGB(255, 245, 251, 255),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                },
                icon: Icon(
                  widget.mode == 'dark'
                      ? Icons.home_filled
                      : Icons.home_outlined,
                  size: MediaQuery.of(context).size.height * 0.04,
                  color: widget.mode == 'dark'
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 0, 8, 20),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/itemlistingform');
                },
                icon: Icon(
                  widget.mode == 'dark'
                      ? Icons.add_circle
                      : Icons.add_circle_outline_rounded,
                  size: MediaQuery.of(context).size.height * 0.04,
                  color: widget.mode == 'dark'
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 0, 8, 20),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  size: MediaQuery.of(context).size.height * 0.04,
                  color: widget.mode == 'dark'
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 0, 8, 20),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
