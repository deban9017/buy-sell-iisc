import 'dart:ui';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:buyandsell/auth/auth.dart';
// import 'package:buyandsell/pages/loading_home.dart';

import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:buyandsell/auth/firebase_options.dart';
// import 'package:flutter_svg/flutter_svg.dart'; //FIREBASE

//initialize SignIn class.
//properties already defines.
//use signIn Widget to get the sign in card.
//use email and password to get the email and password entered by the user
//TODO: Add validation to email and password in the button onPressed function
//use signUp Widget to get the sign up card.
//TODO: Set password as some random string and send password reset email

class SignIn {
  String email = '';
  String password = '';
  String mode = ''; // dark or light

  SignIn({this.email = '', this.password = '', this.mode = 'dark'});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController waController = TextEditingController();

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

  double borderRadius = 17.0;
  double focusBorderRadius = 15.0;
  double totalBorderRadius = 20.0;
  double focusBorderWidth = 2.0;
  double totalBorderWidth = 2.0;
  double buttonBorderRadius = 17.0;
  double buttonBorderWidth = 2.0;

  void getTheme() {
    if (mode == 'dark') {
      bgColor = Color.fromARGB(221, 13, 13, 40);
      textColor = Color.fromARGB(255, 255, 255, 255);
      focusColor = Color.fromARGB(255, 138, 181, 255);
      totalBorderColor = Color.fromARGB(255, 159, 199, 255);
      borderColor = Color.fromARGB(255, 85, 126, 183);
      buttonColor = Color.fromARGB(255, 255, 255, 255);
      buttonBorderColor = Color.fromARGB(255, 0, 255, 195);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 215, 215, 215);
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
    }
  }

  bool validateEmail(String email) {
    //only emails with @iisc.ac.in domain allowed
    //check if last 11 characters are @iisc.ac.in
    if (email.length < 13) {
      return false;
    }
    if (email.substring(email.length - 11) == '@iisc.ac.in') {
      print('Valid email: $email');
      return true;
    }
    return false;
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

  bool validateName(String name) {
    if (name.length > 0) {
      return true;
    }
    return false;
  }

  String getRandomString() {
    //int length random btw 6 to 8
    final length = Random().nextInt(3) + 6;
    final chars =
        'AaBbCcDdEeFfGgH!@%#hIiJjKkLlM^&*(_(mNnOoPpQqRrSs!@^)*TtUuVvWwXxYyZz1234567890!@#%&*()^_';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Widget signIn(BuildContext context) {
    bool _passwordVisible = true;
    getTheme();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(totalBorderRadius),
            side: BorderSide(color: totalBorderColor, width: totalBorderWidth),
          ),
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: Text('Sign In',
                    style: TextStyle(
                        fontSize: 25,
                        color: textColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
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
                        Icons.email,
                        color: iconColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: passwordController,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: borderColor,
                          width: 1.0,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.key_rounded,
                            color: iconColor,
                          ),
                          onPressed: () {
                            _passwordVisible = !_passwordVisible;
                            //set state cannot be used here
                            //TODO: Find a way to update the state of the widget
                          })),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    side: BorderSide(
                        color: buttonBorderColor, width: buttonBorderWidth),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(buttonBorderRadius)),
                  ),
                  onPressed: () async {
                    print('Email: ${emailController.text}');
                    print('Password: ${passwordController.text}');
                    email = (emailController.text).trim().toLowerCase();
                    password = passwordController.text;

                    //No need to validate here
                    //Show Loading Widget while signing in

                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );

                    // print('Email: ${email}');
                    // print('Password: ${password}');

                    AuthService _auth = AuthService();

                    // dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);
                    // print(result);
                    if (FirebaseAuth.instance.currentUser != null) {
                      //snackbar to show successful sign in
                      SnackBar snackBar = SnackBar(
                        content: Text('Sign in successful'),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      //show error dialogue box and Navigate to sign in page again
                      SnackBar snackBar = const SnackBar(
                        content: Text('Invalid email or password'),
                        backgroundColor: Colors.red,
                      );
                      await ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Navigator.pushReplacementNamed(context, '/signin');
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Widget signUp(BuildContext context) {
    getTheme();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(totalBorderRadius),
            side: BorderSide(color: totalBorderColor, width: totalBorderWidth),
          ),
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: Text('Sign Up',
                    style: TextStyle(
                        fontSize: 25,
                        color: textColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
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
                        Icons.person,
                        color: iconColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: waController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    focusColor: focusColor,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: focusColor, width: focusBorderWidth),
                      borderRadius: BorderRadius.circular(focusBorderRadius),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(
                        color: borderColor,
                        width: 1.0,
                      ),
                    ),
                    prefixStyle: TextStyle(
                        color: textColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400),
                    prefixText: '+91 ',
                    labelText: 'Whatsapp',
                    labelStyle: TextStyle(
                        color: textColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400),
                    suffixIcon: Icon(
                      Icons.phone,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
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
                        Icons.email,
                        color: iconColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    side: BorderSide(
                        color: buttonBorderColor, width: buttonBorderWidth),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(buttonBorderRadius)),
                  ),
                  onPressed: () async {
                    email = (emailController.text).trim().toLowerCase();
                    String _wa = waController.text.trim();
                    String _name = nameController.text.trim();
                    if (validateName(_name)) {
                      if (validateWa(_wa)) {
                        if (validateEmail(email) == true) {
                          await Firebase.initializeApp(
                            options: DefaultFirebaseOptions.currentPlatform,
                          );

                          print('Email: ${email}');
                          passwordResetEmailSent(context); //dialogue box

                          AuthService _auth = AuthService();

                          String pass = getRandomString();
                          print('Random password: $pass');
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, pass);
                          _auth.sendPasswordResetEmail(email);

                          print(result);
                          if (FirebaseAuth.instance.currentUser != null) {
                            //_______________________________________________________________
                            final database =
                                FirebaseFirestore.instance; //FIREBASE
                            database.settings = const Settings(
                              persistenceEnabled: true,
                            );
                            CollectionReference userStack =
                                await FirebaseFirestore.instance
                                    .collection('userstack');

                            List userStackList = [];
                            //open doc 'stack' within that there is array 'data' which contains map {email: email, initpass: pass}
                            //add this map to the existing array
                            await userStack.doc('stack').get().then((doc) {
                              if (doc.exists) {
                                userStackList = doc['data'];
                                userStackList
                                    .add({'email': email, 'initpass': pass});
                                userStack
                                    .doc('stack')
                                    .update({'data': userStackList});
                              } else {
                                userStack.doc('stack').set({
                                  'data': [
                                    {'email': email, 'initpass': pass}
                                  ]
                                });
                              }
                            });

                            //add user to user collection
                            CollectionReference users = await FirebaseFirestore
                                .instance
                                .collection('users');
                            //add new doc, add fields email, uid, seller_name, wa_no
                            users.add({
                              'email': email,
                              'uid': FirebaseAuth.instance.currentUser!.uid,
                              'seller_name': _name,
                              'wa_no': _wa,
                            });

                            //_______________________________________________________________

                            _auth.signOut();
                          }
                        } else {
                          //show error dialogue box and Navigate to sign up page again
                          print('Invalid email');
                          SnackBar snackBar = SnackBar(
                            content: Text(
                                'Please enter a valid IISc email address',
                                style: TextStyle(color: textColor)),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            'Please enter a valid Whatsapp number',
                            style: TextStyle(color: textColor),
                          ),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'Please enter your name',
                          style: TextStyle(color: textColor),
                        ),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  //forgot password widget
  Widget forgotPass(BuildContext context) {
    getTheme();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(totalBorderRadius),
            side: BorderSide(color: totalBorderColor, width: totalBorderWidth),
          ),
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: Text('Forgot Password',
                    style: TextStyle(
                        fontSize: 25,
                        color: textColor,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Enter your email address below to receive a password reset link.',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sidePad, vertical: verticalPad),
                child: TextField(
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400),
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      focusColor: focusColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: focusColor, width: focusBorderWidth),
                        borderRadius: BorderRadius.circular(focusBorderRadius),
                      ),
                      enabledBorder: OutlineInputBorder(
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
                        Icons.email,
                        color: iconColor,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    side: BorderSide(
                        color: buttonBorderColor, width: buttonBorderWidth),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(buttonBorderRadius)),
                  ),
                  onPressed: () async {
                    email = (emailController.text).trim().toLowerCase();
                    if (validateEmail(email) == true) {
                      await Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      );

                      print('Email: ${email}');
                      passwordResetEmailSent(context); //dialogue box
                      AuthService _auth = AuthService();
                      _auth.sendPasswordResetEmail(
                          email); //send password reset email
                    } else {
                      //show error dialogue box and Navigate to sign up page again
                      print('Invalid email');
                      SnackBar snackBar = SnackBar(
                        content:
                            Text('Please enter a valid IISc email address'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushReplacementNamed(context, '/forgotpass');
                    }
                    //TODO: Add navigation to home page and send password reset email
                    //also set password as some random string
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  //password reset email sent dialogue box
  void passwordResetEmailSent(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: bgColor,
            // title: Text('Password Reset Email Sent'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
              ),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(totalBorderRadius),
                    side: BorderSide(
                        color: totalBorderColor, width: totalBorderWidth),
                  ),
                  color: bgColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 0),
                        child: Text(
                          '''A password reset email has been sent to your provided email address. After resetting your password, you can sign in with the new password.''',
                          style: TextStyle(
                              color: buttonTextColor,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
            actions: [
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    side: BorderSide(
                        color: buttonBorderColor, width: buttonBorderWidth),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(buttonBorderRadius)),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/signin');
                    //TODO: Navigate later to signin page
                    //TODO: Add navigation to home page and send password reset email
                    //also set password as some random string
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          );
        });
  }
}
