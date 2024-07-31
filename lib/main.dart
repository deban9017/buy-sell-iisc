import 'package:buyandsell/pages/internal_pages/all_category.dart';
import 'package:buyandsell/pages/loading_home.dart';
import 'package:buyandsell/pages/options.dart';
import 'package:buyandsell/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/pages/home.dart';
import 'package:buyandsell/pages/signup_page.dart';
import 'package:buyandsell/pages/signin_page.dart';
import 'package:buyandsell/pages/forgotpass_page.dart';
import 'package:buyandsell/pages/internal_pages/item_listing_form.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:buyandsell/auth/firebase_options.dart';
import 'package:provider/provider.dart'; //FIREBASE
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //This is required for Firebase core to initialize properly
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //FIREBASE
  final database = FirebaseFirestore.instance; //FIREBASE
  database.settings = const Settings(
    persistenceEnabled: true,
  );

  // print('Starting main');

  String mode = 'dark'; // dark or light //USER_VARIABLE
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('mode')) {
    mode = prefs.getString('mode')!;
  } else {
    prefs.setString('mode', mode);
  }

  // print('Starting main');

  runApp(StreamProvider<User?>.value(
    value: FirebaseAuth.instance.authStateChanges(),
    initialData: null,
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(
              mode: mode,
            ),
        '/loading': (context) => LoadingHome(
              mode: mode,
            ),
        '/home': (context) => Home(
              mode: mode,
            ),
        '/signup': (context) => SignupPage(
              mode: mode,
            ),
        '/signin': (context) => SigninPage(
              mode: mode,
            ),
        '/forgotpass': (context) => ForgotpassPage(
              mode: mode,
            ),
        '/allcategory': (context) => AllCategory(
              dataList: [],
              mode: mode,
            ),
        '/itemlistingform': (context) => ItemListingForm(
              mode: mode,
            ),
        '/options': (context) => Options(mode: mode),
      },
    ),
  ));
}
