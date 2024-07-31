import 'package:buyandsell/pages/internal_pages/details.dart';
import 'package:buyandsell/pages/internal_pages/edit_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Itemcard {
  String mode = ''; // dark or light

  Itemcard({this.mode = 'dark', cardsperrow = 2});

  late Color bgColor;
  late Color textColor;
  late Color priceColor;
  late Color borderColor;
  late Color totalBorderColor;
  late Color buttonColor;
  late Color buttonTextColor;
  late Color iconColor;
  late Color labelColor;

  int cardsperrow = 2; //to be supplied, as used in the gridview
  late double totalWidth;

  double borderRadius = 10.0;
  double borderWidth = 0.0;
  double sideMargin = 10.0;
  double verticalMargin = 0.0;
  double cardelemsidepad = 10.0;

  void getTheme() {
    if (mode == 'dark') {
      bgColor = Color.fromARGB(255, 44, 53, 69);
      textColor = Color.fromARGB(255, 255, 255, 255);
      priceColor = Color.fromARGB(255, 164, 255, 167);
      totalBorderColor = Color.fromARGB(255, 159, 199, 255);
      borderColor = Color.fromARGB(255, 60, 61, 63);
      buttonColor = Color.fromARGB(255, 255, 255, 255);
      buttonTextColor = Color.fromARGB(255, 255, 255, 255);
      iconColor = Color.fromARGB(255, 104, 122, 158);
      labelColor = Color.fromARGB(255, 61, 73, 95);
    } else {
      bgColor = Color.fromARGB(255, 255, 255, 255);
      textColor = Color.fromARGB(255, 0, 13, 32);
      priceColor = Color.fromARGB(255, 32, 32, 32);
      totalBorderColor = Color.fromARGB(255, 0, 35, 83);
      borderColor = Color.fromARGB(255, 60, 101, 163);
      buttonColor = Color.fromARGB(255, 0, 0, 0);
      buttonTextColor = Color.fromARGB(255, 0, 13, 32);
      iconColor = Color.fromARGB(255, 100, 100, 100);
      labelColor = Color.fromARGB(255, 162, 162, 162);
    }
  }

  void setValues(context) {
    getTheme();
    totalWidth = MediaQuery.of(context).size.width.floorToDouble();
    // print(totalWidth);
  }

  double getFontSize(context) {
    double fontSize = 17.0;

    //TODO: Add logic to change font size based on screen size

    return fontSize;
  }

  Icon getStateIcon(state) {
    late Icon icon;
    if (state == 0) {
      icon = Icon(
        size: 17,
        Icons.hdr_auto,
        color: Color.fromARGB(255, 0, 201, 56),
      );
    } else if (state == 1) {
      icon = Icon(
        size: 17,
        // CupertinoIcons.minus_circle_fill,
        Icons.do_not_disturb_on_total_silence_sharp,
        color: Color.fromARGB(255, 254, 189, 47),
      );
    } else if (state == 2) {
      icon = Icon(
        size: 17,
        CupertinoIcons.xmark_circle_fill,
        color: Color.fromARGB(255, 255, 87, 82),
      );
    } else {
      icon = Icon(
        size: 17,
        Icons.circle,
        color: Color.fromARGB(255, 100, 100, 100),
      );
    }
    return icon;
  }

  Widget getLogoOrImage(context, imagepath) {
    if (imagepath.contains('.svg')) {
      return logo(context, totalWidth, textColor);
    } else {
      try {
        return SizedBox(
            width: getLogoDim(totalWidth, cardsperrow) - 10.5,
            height: getLogoDim(totalWidth, cardsperrow),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child:
                    Image(image: NetworkImage(imagepath), fit: BoxFit.cover)));
      } catch (e) {
        return logo(context, totalWidth, textColor);
      }
    }
  }

  Widget itemCard(
    BuildContext context, {
    Map dataMap = const {},
  }) {
    // String id = dataMap['id'] == null ? '' : dataMap['id'].toString();
    String title =
        dataMap['item_name'] == null ? '' : dataMap['item_name'].toString();
    String price =
        dataMap['price']['sp'] == null ? '' : dataMap['price']['sp'].toString();
    String email = dataMap['contact_details']['email'] == null
        ? ''
        : dataMap['contact_details']['email'].toString();
    String imagepath;
    if (dataMap['photo1url'] == '' &&
        dataMap['photo2url'] == '' &&
        dataMap['photo3url'] == '' &&
        dataMap['photo4url'] == '') {
      imagepath = 'lib/Assets/Images/logo.svg';
    } else {
      if (dataMap['photo1url'] != '') {
        imagepath = dataMap['photo1url'].toString();
      } else if (dataMap['photo2url'] != '') {
        imagepath = dataMap['photo2url'].toString();
      } else if (dataMap['photo3url'] != '') {
        imagepath = dataMap['photo3url'].toString();
      } else if (dataMap['photo4url'] != '') {
        imagepath = dataMap['photo4url'].toString();
      } else {
        imagepath = 'lib/Assets/Images/logo.svg';
      }
    }

    // 'lib/Assets/Images/logo.svg'; //TODO: Add image path from dataMap
    int state = dataMap['state'] == null ? 0 : dataMap['state'];
    //state 0 for available, 1 for booked, 2 for sold //RULE
    setValues(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width / cardsperrow,
      // height: MediaQuery.of(context).size.width / cardsperrow,
      child: Card(
          elevation: 8.0,
          margin: EdgeInsets.only(
              left: sideMargin,
              right: sideMargin,
              top: verticalMargin,
              bottom: verticalMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: bgColor,
          child: InkWell(
            //Inkwell is used to make the card clickable
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Details(mode: mode, dataMap: dataMap)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    getLogoOrImage(context, 'lib/Assets/Images/logo.svg'),
                    getLogoOrImage(context, imagepath),
                    (email == FirebaseAuth.instance.currentUser!.email)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditItem(
                                              mode: mode, dataMap: dataMap)));
                                  //TODO: Add edit function
                                  //Identify editable fields
                                  //pass dataMap to edit page
                                  //On save, update the data in firebase
                                  //make separate edit page
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, right: 5),
                                  child: const CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(159, 255, 255, 255),
                                    radius: 20,
                                    child: Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: cardelemsidepad),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        maxLines: 1, // Set maximum lines to 1
                        overflow: TextOverflow.ellipsis,
                        title,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          fontSize: getFontSize(context),
                        ),
                      ),
                    ),
                  ]),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: cardelemsidepad),
                          child: Text(
                            '₹${price}',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: mode == 'dark'
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: priceColor,
                              fontSize: getFontSize(context),
                            ),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: cardelemsidepad),
                      child: getStateIcon(state),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }

  Widget dummyCard(BuildContext context) {
    String imagepath = 'lib/Assets/Images/logo.svg';

    //state 0 for available, 1 for booked, 2 for sold //RULE
    setValues(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width / cardsperrow,
      // height: MediaQuery.of(context).size.width / cardsperrow,
      child: Card(
          elevation: 8.0,
          margin: EdgeInsets.only(
              left: sideMargin,
              right: sideMargin,
              top: verticalMargin,
              bottom: verticalMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: bgColor,
          child: InkWell(
            //Inkwell is used to make the card clickable
            onTap: () {
              print('Card tapped'); //No function for dummy card
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                getLogoOrImage(context, imagepath),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: cardelemsidepad),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: getFontSize(context),
                        color: labelColor,
                      ),
                    ),
                  ]),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                        padding: EdgeInsets.only(left: cardelemsidepad),
                        child: Container(
                          height: getFontSize(context),
                          color: labelColor,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.only(right: cardelemsidepad),
                        child: Container(
                          width: 14,
                          height: 14,
                          color: labelColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }

  double getLogoDim(totalWidth, cardsperrow) {
    // print(totalWidth);
    double logoDim =
        ((totalWidth - (sideMargin * 2)) / cardsperrow).floorToDouble();
    // print(logoDim);
    return logoDim;
  }

  Widget logo(context, totalWidth, color) {
    return Container(
      width: getLogoDim(totalWidth, cardsperrow),
      height: getLogoDim(totalWidth, cardsperrow),
      child: SvgPicture.asset(
        'lib/Assets/Images/logo.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
