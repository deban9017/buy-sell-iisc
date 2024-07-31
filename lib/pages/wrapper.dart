// ignore_for_file: must_be_immutable

import 'package:buyandsell/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:buyandsell/pages/loading_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  Wrapper({super.key, required this.mode});
  String mode = 'dark'; // dark or light

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('mode');
    try {
      widget.mode = mode!;
    } catch (e) {
      widget.mode = 'dark';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); //FIREBASE
    // print('user: $user'); //FIREBASE

    if (user == null) {
      return SignupPage(
        mode: widget.mode,
      );
    } else {
      return LoadingHome(
        mode: widget.mode,
      );
    }
  }
}
