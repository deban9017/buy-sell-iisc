// ignore_for_file: must_be_immutable

import 'package:buyandsell/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:buyandsell/auth/firebase_options.dart';

class LoadingHome extends StatefulWidget {
  LoadingHome({super.key, required this.mode});
  String mode = 'dark'; // dark or light

  @override
  State<LoadingHome> createState() => _LoadingHomeState();
}

class _LoadingHomeState extends State<LoadingHome> {
  bool loading = true;
  Future<Map> data = Future.value({});

  initdata() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); //FIREBASE
    final database = FirebaseFirestore.instance; //FIREBASE
    database.settings = const Settings(
      persistenceEnabled: true,
    );
    CollectionReference studentCollection =
        FirebaseFirestore.instance.collection('itemlisting');
    // print('CHECKING');
    // print(studentCollection.snapshots().first);
    await studentCollection.snapshots().listen((event) {
      event.docs.forEach((element) {
        // print(data[element.id] = element.data());
        data = Future.value({element.id: element.data()});
      });
      print('1. Data stored from loading home');
      setState(() {
        print('2. Setting state');

        loading = false;

        // print('3. loading done');
      });
    });
    // print(data);

    // print('4. initstate done');
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    loading = false; //TESTSTING
    // initdata();
    // print('5. initstate end');
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Home(mode: widget.mode)
        : Scaffold(
            body: Container(
                color: const Color.fromARGB(255, 22, 31, 83),
                child: const Center(
                    child: SpinKitFadingCircle(
                  color: Color.fromARGB(255, 167, 223, 255),
                  size: 65.0,
                ))));
  }
}
