import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Categorycard {
  String mode = ''; // dark or light

  Categorycard({
    this.mode = 'dark',
    cardsperrow = 2,
  });

  late Color bgColor;
  late Color textColor;
  late Color borderColor;
  late Color totalBorderColor;
  late Color buttonColor;
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
      buttonColor = Color.fromARGB(255, 255, 255, 255);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 215, 228, 255);
    } else {
      bgColor = Color.fromARGB(255, 255, 255, 255);
      textColor = Color.fromARGB(255, 0, 8, 20);
      totalBorderColor = Color.fromARGB(255, 0, 35, 83);
      borderColor = Color.fromARGB(255, 60, 101, 163);
      buttonColor = Color.fromARGB(255, 0, 0, 0);
      buttonTextColor = Color.fromARGB(255, 0, 13, 32);
      iconColor = Color.fromARGB(255, 63, 63, 63);
    }
  }

  void setValues(context) {
    getTheme();
    
    totalWidth = MediaQuery.of(context).size.width.floorToDouble();
    // print('totalwidth: $totalWidth');
  }

  double getFontSize(context) {
    double fontSize = 19.0;

    //TODO: Add logic to change font size based on screen size

    return fontSize;
  }

  double getIconSize(context) {
    int getCrossAxisCount() {
      double width = MediaQuery.of(context).size.width;
      int crossAxisCount = 2;
      if (width > 1400) {
        crossAxisCount = 8;
      } else if (width > 1200) {
        crossAxisCount = 7;
      } else if (width > 1000) {
        crossAxisCount = 6;
      } else if (width > 800) {
        crossAxisCount = 5;
      } else if (width > 600) {
        crossAxisCount = 4;
      } else if (width > 400) {
        crossAxisCount = 3;
      }
      return crossAxisCount;
    }

    double iconSize = ((totalWidth / getCrossAxisCount()) - 30) * 0.44;
    // print('cardsperrow: $cardsperrow');
    // print('iconsize: $iconSize');

    return iconSize;
  }

  Widget categoryCard(BuildContext context,
      {String title = '', required Icon icon, required Function onPressed}) {
    //state 0 for available, 1 for booked, 2 for sold //RULE
    setValues(context);
    // print(mode);
    return SizedBox(
      width: 150,
      // height: MediaQuery.of(context).size.width / cardsperrow + 50,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: bgColor,
        child: InkWell(
          //Inkwell is used to make the card clickable
          onTap: () {
            onPressed();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon,
                color: iconColor,
                size: getIconSize(context),
                weight: 600,
              ),
              SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    fontSize: getFontSize(context),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
