// ignore_for_file: must_be_immutable

import 'package:buyandsell/pages/internal_pages/all_items.dart';
import 'package:buyandsell/widgets/itemlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/widgets/categories_row.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:buyandsell/functions/homedataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buyandsell/auth/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.mode});
  Future<Map> data = Future.value({});
  String mode = 'dark'; // dark or light
  int latestItemrows = 5;

  bool dataLoaded = false;
  bool isStateSet = false;
  Map fetchedData = {};
  Homedataclass result = Homedataclass(data: {});
  List dataList = [];
  List latestItems = [];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Future<void> initDataHome() async {
      Map data = {};

      //mode_____________________________________________
      final prefs = await SharedPreferences.getInstance();
      final mode = prefs.getString('mode');
      try {
        widget.mode = mode!;
      } catch (e) {
        widget.mode = 'dark';
      }

      if (widget.isStateSet == false) {
        if (FirebaseAuth.instance.currentUser != null) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ); //FIREBASE
          final database = FirebaseFirestore.instance; //FIREBASE
          database.settings = const Settings(
            persistenceEnabled: true,
          );
          CollectionReference studentCollection =
              await FirebaseFirestore.instance.collection('itemlisting');
          CollectionReference itemStackCollection =
              await FirebaseFirestore.instance.collection('itemstack');

          List latestIdMaps = [];

          itemStackCollection.doc('stack').get().then((value) {
            //take the last 10 items from the stack, if less than 10, take all
            List itemStack = value['data'];
            if (itemStack.length < widget.latestItemrows) {
              latestIdMaps = itemStack;
            } else {
              latestIdMaps =
                  itemStack.sublist(itemStack.length - widget.latestItemrows);
            }
            latestIdMaps = latestIdMaps.reversed.toList();
            studentCollection.snapshots().listen((event) {
              event.docs.forEach((element) {
                data[element.id] = element.data();
              });
              widget.dataLoaded = true;

              widget.fetchedData = data;
              widget.result = Homedataclass(data: widget.fetchedData);

              widget.dataList = widget.result.maptoList(widget.result.data);

              for (var _id in latestIdMaps) {
                for (var item in widget.dataList) {
                  if (item['id'] == _id['id']) {
                    widget.latestItems.add(item);
                  }
                }
              }

              setState(() {
                if (widget.dataLoaded) {
                  //delete the items which has ['state'] == 2
                  List temp = [];
                  for (var item in widget.dataList) {
                    if (item['state'] != 2) {
                      temp.add(item);
                    }
                  }
                  widget.dataList = temp;

                  widget.isStateSet = true;
                }
              });
            });
          });
        }
      }

      // if (!widget.dataLoaded) {
      //     widget.data.then((value) {
      //       //This is a future, so it will be executed after the build function is executed
      //       widget.fetchedData = value;
      //       widget.result = Homedataclass(data: widget.fetchedData);

      //       widget.dataList = widget.result.maptoList(widget.result.data);
      //       // print('Data list is ${widget.dataList}');

      //       for (var item in widget.dataList) {
      //         ItemCardData itemCardData = ItemCardData(dataMap: item);
      //         itemCardData.assignData();
      //         print('Fetching data from ');
      //       }
      //       print('FROM WITHIN code block______Data list is ${widget.dataList}');
      //       setState(() {
      //         widget.dataLoaded =
      //             true; //This is to prevent the future from being executed again
      //         print('New State Set to ______________ {${widget.dataLoaded}}');
      //       });
      //     });
      //   }
    }

    SizedBox sizedBox = const SizedBox(
      width: 16.0,
    );

    if (!widget.isStateSet) {
      initDataHome();
    }

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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(
                0.0), //context passed before padding and margin, so overflow error if padded or margin is used
            //use separate outer container for padding and margin, containing this widget.
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                CategoriesRow(
                  dataList: widget.dataList,
                  mode: widget.mode,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  //Latest Items Header
                  children: [
                    sizedBox,
                    Expanded(
                      child: Text(
                        'Latest Items',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            color: widget.mode == 'dark'
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 0, 8, 20),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllItems(
                            heading: 'All Items',
                            category: 'all',
                            mode: widget.mode,
                            dataList: widget.dataList,
                          );
                        }));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                        child: Row(
                          children: [
                            Text(
                              'See All',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.blue,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17.0,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                    sizedBox,
                  ],
                ),
                Itemlist(
                  mode: widget.mode,
                  dataList: widget.latestItems,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
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
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/options', (Route<dynamic> route) => false);
                  },
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
      ),
    );
  }
}
