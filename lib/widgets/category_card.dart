// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed,
      required this.dim,
      required this.mode,
      required this.fontsize});
  Icon icon;
  String title;
  Function onPressed;
  double dim;
  String mode;
  double fontsize;

  late Color bgColor;
  late Color textColor;
  late Color borderColor;
  late Color totalBorderColor;
  late Color buttonTextColor;
  late Color iconColor;

  int cardsperrow = 2; //to be supplied, as used in the gridview
  late double totalWidth;

  double borderRadius = 24.0;
  double borderWidth = 0.0;
  double sideMargin = 10.0;
  double verticalMargin = 0.0;
  double cardelemsidepad = 10.0;

  void getTheme() {
    if (mode == 'dark') {
      bgColor = Color.fromARGB(255, 44, 53, 69);
      textColor = Color.fromARGB(255, 255, 255, 255);
      totalBorderColor = Color.fromARGB(255, 159, 199, 255);
      borderColor = Color.fromARGB(255, 60, 61, 63);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 215, 228, 255);
    } else {
      bgColor = Color.fromARGB(255, 255, 255, 255);
      textColor = Color.fromARGB(255, 0, 8, 20);
      totalBorderColor = Color.fromARGB(255, 0, 35, 83);
      borderColor = Color.fromARGB(255, 60, 101, 163);
      buttonTextColor = Color.fromARGB(255, 0, 13, 32);
      iconColor = Color.fromARGB(255, 63, 63, 63);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 17, 17, 17).withOpacity(0.3),
                  spreadRadius: 0.4,
                  blurRadius: 2.5,
                  offset: Offset(1, 5), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            width: dim,
            height: dim,
            child: InkWell(
                onTap: () {
                  onPressed();
                },
                child: Center(
                  child: Icon(
                    icon.icon,
                    size: dim * 0.57,
                    color: iconColor,
                  ),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Nunito',
              fontSize: fontsize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
