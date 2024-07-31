// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:buyandsell/widgets/horiz_div.dart';

class Details extends StatelessWidget {
  Details({super.key, required this.mode, required this.dataMap});
  final String mode;
  Map dataMap;
  double imageBorderRadius = 15.0;
  String url = '';
  List<String> urlList = []; //TODO: get image urls from dataMap

  double horizontalDivWidth = 25.0;
  double maxwidth = 450.0;

  late Color bgColor;
  late Color textColor;
  late Color focusColor;
  late Color borderColor;
  late Color totalBorderColor;
  late Color buttonColor;
  late Color buttonTextColor;
  late Color buttonBorderColor;
  late Color iconColor;
  late Color labelColor;
  late Color dividerColor;
  Color soldcolor = Color.fromARGB(255, 255, 87, 82);
  Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
  Color availablecolor = Color.fromARGB(255, 0, 201, 56);

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
      labelColor = Color.fromARGB(255, 27, 27, 65);
      dividerColor = Color.fromARGB(221, 37, 37, 82);
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
      labelColor = Color.fromARGB(255, 227, 227, 227);
      dividerColor = Color.fromARGB(255, 160, 160, 160);
    }
  }

  String getCondition(int condition) {
    String conditionText = '';
    //RULE:
    // 5 for brand new,unused
    // 4 for like new, excellent
    // 3 for good
    // 2 for fair
    // 1 for old but usable
    // 0 for no data
    switch (condition) {
      case 5:
        conditionText = 'Brand New, Unused';
        break;
      case 4:
        conditionText = 'Like New, Excellent';
        break;
      case 3:
        conditionText = 'Good';
        break;
      case 2:
        conditionText = 'Fair';
        break;
      case 1:
        conditionText = 'Old but Usable';
        break;
      default:
        conditionText = 'No Data';
    }
    return conditionText;
  }

  String getUsedFor(int usedFor) {
    String usedForText = '';
    //RULE:
    // -2 used once or twice
    // -1 for less than a week
    // 0 for unused
    // 1 for less than a month
    // 2 for less than 2 months
    // 3 for less than 3 months
    // 4 for less than 6 months
    // 5 for less than a year
    // 6 for less than 2 years
    // 7 for 3 years
    // 8 for 4 years
    // 9 for 5 years
    // 10 for more than 5 years
    switch (usedFor) {
      case -2:
        usedForText = 'Used Once or Twice';
        break;
      case -1:
        usedForText = 'Less than a Week';
        break;
      case 0:
        usedForText = 'Unused';
        break;
      case 1:
        usedForText = 'Less than a Month';
        break;
      case 2:
        usedForText = 'Less than 2 Months';
        break;
      case 3:
        usedForText = 'Less than 3 Months';
        break;
      case 4:
        usedForText = 'Less than 6 Months';
        break;
      case 5:
        usedForText = 'Less than a Year';
        break;
      case 6:
        usedForText = 'Less than 2 Years';
        break;
      case 7:
        usedForText = '3 Years';
        break;
      case 8:
        usedForText = '4 Years';
        break;
      case 9:
        usedForText = '5 Years';
        break;
      case 10:
        usedForText = 'More than 5 Years';
        break;
      default:
        usedForText = 'No Data';
    }
    return usedForText;
  }

  String getStoreIconPath(String store) {
    String path = '';
    //remove spaces, and convert to lowercase
    store = store.replaceAll(' ', '').toLowerCase();

    if (store.contains('amazon')) {
      path = 'lib/Assets/Images/amazon_icon.svg';
    } else if (store.contains('flipkart')) {
      path = 'lib/Assets/Images/flipkart_icon.svg';
    } else if (store.contains('myntra')) {
      path = 'lib/Assets/Images/myntra_icon.svg';
    } else if (store.contains('ajio')) {
      path = 'lib/Assets/Images/ajio_icon.svg';
    } else {
      path = 'lib/Assets/Images/cart_icon.svg';
    }

    // switch (store) {
    //   case 'amazon':
    //     path = 'lib/Assets/Images/amazon_icon.svg';
    //     break;
    //   case 'flipkart':
    //     path = 'lib/Assets/Images/flipkart_icon.svg';
    //     break;
    //   case 'myntra':
    //     path = 'lib/Assets/Images/myntra_icon.svg';
    //     break;
    //   case 'ajio':
    //     path = 'lib/Assets/Images/ajio_icon.svg';
    //     break;
    //   default:
    //     path = 'lib/Assets/Images/cart_icon.svg';
    // }

    return path;
  }

  bool screenHeightGreater(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (height > width) {
      return true;
    } else {
      return false;
    }
  }

  void setValues() {
    if (dataMap['photo1url'] != '') {
      urlList.add(dataMap['photo1url']);
    }
    if (dataMap['photo2url'] != '') {
      urlList.add(dataMap['photo2url']);
    }
    if (dataMap['photo3url'] != '') {
      urlList.add(dataMap['photo3url']);
    }
    if (dataMap['photo4url'] != '') {
      urlList.add(dataMap['photo4url']);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    setValues();

    return SafeArea(
        child: Scaffold(
      backgroundColor: mode == 'dark'
          ? Color.fromARGB(255, 3, 14, 34)
          : Color.fromARGB(255, 245, 251, 255),
      appBar: AppBar(
        backgroundColor: mode == 'dark'
            ? Color.fromARGB(255, 3, 14, 34)
            : Color.fromARGB(255, 245, 251, 255),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            weight: 200,
            size: 24.0,
            color: mode == 'dark'
                ? Color.fromARGB(255, 255, 255, 255)
                : Color.fromARGB(255, 0, 8, 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('All Items',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: mode == 'dark'
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color.fromARGB(255, 0, 8, 20),
              fontSize: 27.0,
              fontWeight: FontWeight.w800,
            )),
      ),
      body: Container(
        color: mode == 'dark'
            ? Color.fromARGB(255, 3, 14, 34)
            : Color.fromARGB(255, 245, 251, 255),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'in ',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                                fontFamily: 'Nunito'),
                          ),
                        ),
                        SizedBox(width: 3.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          decoration: BoxDecoration(
                            color: labelColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(dataMap['category'],
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                  fontFamily: 'Nunito')),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            'seller ',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                                fontFamily: 'Nunito'),
                          ),
                        ),
                        SizedBox(width: 3.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          decoration: BoxDecoration(
                            color: labelColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(('@${dataMap['seller_name']}'),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                  fontFamily: 'Nunito')),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Stack(children: [
                CarouselSlider(
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.45),
                  items: [
                    for (url in urlList)
                      Container(
                        child: Stack(children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: SvgPicture.asset(
                                'lib/Assets/Images/logo.svg',
                                colorFilter: ColorFilter.mode(
                                    iconColor, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen(imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png')));
                            },
                            onLongPress: () {
                              //implement download image alert dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Download Image?'),
                                    content: Text(
                                        'Do you want to download this image?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            //implement download image
                                            var response =
                                                await http.get(Uri.parse(url));
                                            Directory? appDocDir =
                                                await getApplicationDocumentsDirectory();
                                            print(appDocDir);
                                            File file = new File(path.join(
                                                appDocDir.path,
                                                path.basename(url)));
                                            print(path.join(appDocDir.path,
                                                path.basename(url)));
                                            await file.writeAsBytes(
                                                response.bodyBytes);
                                            print('wrote file');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Image downloaded'),
                                              ),
                                            );
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Image Downloaded'),
                                                    content: Image.file(file),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('OK'))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text('Yes')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No')),
                                    ],
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(imageBorderRadius),
                              child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(url)),
                            ),
                          ),
                        ]),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        //implement share
                      },
                      child: const CircleAvatar(
                        backgroundColor: Color.fromARGB(163, 255, 255, 255),
                        child: Icon(Icons.share_rounded,
                            color: Color.fromARGB(255, 20, 20, 20)),
                      ),
                    ),
                    SizedBox(width: 20.0),
                  ],
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(dataMap['item_name'],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: mode == 'dark'
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Nunito')),
                      HorizontalDiv(
                          dividerColor: dividerColor,
                          width: horizontalDivWidth,
                          span: 0.96,
                          thickness: 1),
                      (dataMap['description'] != '')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description:',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: textColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400),
                                ),
                                ExpandableText(
                                    text: dataMap['description'],
                                    textcolor: textColor),
                                HorizontalDiv(
                                    dividerColor: dividerColor,
                                    width: horizontalDivWidth,
                                    span: 0.96,
                                    thickness: 1),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ('\u{20B9}${dataMap['price']['sp'].toString()}'), //int or double
                              style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: mode == 'dark'
                                      ? FontWeight.w700
                                      : FontWeight.w800,
                                  color: textColor,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                          NegotiabilityIndicator(
                              state: dataMap['state'],
                              negotiability: dataMap['negotiability']),
                          AvailabilityIndicator(
                              mode: mode,
                              dataMap: dataMap,
                              availablecolor: availablecolor,
                              bookedcolor: bookedcolor,
                              soldcolor: soldcolor),
                        ],
                      ),
                      ((dataMap['price']['cp'] == -1 &&
                                  dataMap['price']['other_price'] == -1) ||
                              (dataMap['price']['cp'] == -1 &&
                                  dataMap['price']['other_store']
                                          .toString()
                                          .trim() ==
                                      ''))
                          ? Container()
                          : Column(
                              children: [
                                SizedBox(height: 6.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (dataMap['price']['cp'] == -1)
                                        ? Container()
                                        : Text(
                                            ('Cost Price: \u{20B9}${dataMap['price']['cp'].toString()}'),
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: textColor,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                    (dataMap['price']['other_price'] == -1 ||
                                            dataMap['price']['other_store']
                                                    .toString()
                                                    .trim() ==
                                                '')
                                        ? Container()
                                        : Text(
                                            ('${dataMap['price']['other_store']} price: \u{20B9}${dataMap['price']['other_price'].toString()}'),
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: textColor,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                      HorizontalDiv(
                          dividerColor: dividerColor,
                          width: horizontalDivWidth,
                          span: 0.96,
                          thickness: 1),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: iconColor),
                          SizedBox(width: 5.0),
                          Text(
                            'Pickup Location: ',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          dataMap['location'].length < 18
                              ? Text(
                                  dataMap['location'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      dataMap['location'].length < 18
                          ? Container()
                          : ExpandableText(
                              text: dataMap['location'], textcolor: textColor),
                      HorizontalDiv(
                          dividerColor: dividerColor,
                          width: horizontalDivWidth,
                          span: 0.96,
                          thickness: 1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Condition:',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: labelColor,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      '${getCondition(dataMap['condition']['used_condition'])}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: textColor,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  (dataMap['condition']['used_condition'] ==
                                              5 ||
                                          dataMap['condition']
                                                  ['used_condition'] ==
                                              4)
                                      ? Icon(
                                          Icons.star_border_rounded,
                                          color: Colors.yellow[700],
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          (dataMap['condition']['used_for'] == -3)
                              ? Container()
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'used for  ',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: textColor,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ), //int or double
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            color: labelColor,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Text(
                                            '${getUsedFor(dataMap['condition']['used_for'])}',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: textColor,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      HorizontalDiv(
                          dividerColor: dividerColor,
                          width: horizontalDivWidth,
                          span: 0.96,
                          thickness: 1),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                'Contact Seller:',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 2.0,
                                      right: 10.0,
                                      top: 3.0,
                                      bottom: 3.0),
                                  decoration: BoxDecoration(
                                    color: labelColor,
                                    borderRadius: BorderRadius.circular(
                                        buttonBorderRadius),
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        String url =
                                            "https://wa.me/+91${dataMap['contact_details']['whatsapp']}/?text=Hello, I would like to buy ${dataMap['item_name']} listed on BuyAndSell.";
                                        launchUrl(Uri.parse(url));
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: SvgPicture.asset(
                                              'lib/Assets/Images/wa_icon.svg',
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          Text('Whatsapp',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: textColor,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      ))),
                              Container(
                                child: Row(
                                  children: [
                                    // Text(
                                    //   'email ',
                                    //   style: TextStyle(
                                    //     fontSize: 15.0,
                                    //     color: textColor,
                                    //     fontFamily: 'Nunito',
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8.0,
                                          right: 6.0,
                                          top: 3.0,
                                          bottom: 3.0),
                                      decoration: BoxDecoration(
                                        color: labelColor,
                                        borderRadius: BorderRadius.circular(
                                            buttonBorderRadius),
                                      ),
                                      child: Center(
                                        child: SelectableText(
                                          dataMap['contact_details']['email'],
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: textColor,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      (dataMap['store_link'] == '' ||
                              dataMap['price']['other_store'] == '')
                          ? const SizedBox(height: 20.0)
                          : Column(
                              children: [
                                HorizontalDiv(
                                    dividerColor: dividerColor,
                                    width: horizontalDivWidth,
                                    span: 0.96,
                                    thickness: 1),
                                Row(
                                  children: [
                                    Text(
                                      'See On ',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: textColor,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    InkWell(
                                      onTap: () {
                                        try {
                                          launchUrl(
                                              Uri.parse(dataMap['store_link']));
                                        } catch (e) {
                                          //Snackbar to show error
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Error opening link'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: labelColor,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: SvgPicture.asset(
                                                getStoreIconPath(
                                                    dataMap['price']
                                                        ['other_store']),
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              '${dataMap['price']['other_store']}',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: textColor,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                    ]),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final textcolor;

  const ExpandableText({Key? key, required this.text, required this.textcolor})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String shortText;
    int maxlen = 69;
    if (widget.text.length > maxlen) {
      shortText = widget.text.substring(0, maxlen) + '... read more';
    } else {
      shortText = widget.text;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? widget.text : shortText,
            style: TextStyle(
              fontSize: 15.0,
              color: widget.textcolor,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ],
    );
  }
}

class AvailabilityIndicator extends StatelessWidget {
  AvailabilityIndicator(
      {super.key,
      required this.mode,
      required this.dataMap,
      required this.availablecolor,
      required this.bookedcolor,
      required this.soldcolor});
  final String mode;
  final Map dataMap;
  final Color availablecolor;
  final Color bookedcolor;
  final Color soldcolor;

  String getDisplayText() {
    String displayText = '';

    if (dataMap['state'] == 2) {
      //sold
      displayText = 'Sold';
    } else if (dataMap['state'] == 1) {
      //booked
      displayText = 'Booked';
    } else {
      //available
      int item_count = dataMap['item_count'];
      if (item_count == 1) {
        displayText = 'Available';
      } else {
        displayText = '$item_count Available';
      }
    }

    return displayText;
  }

  Color getColor() {
    Color color;
    if (dataMap['state'] == 2) {
      //sold
      color = soldcolor;
    } else if (dataMap['state'] == 1) {
      //booked
      color = bookedcolor;
    } else {
      //available
      color = availablecolor;
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.0,
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: getColor(),
      ),
      child: Center(
          child: Text(getDisplayText(),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito',
              ))),
    );
  }
}

class NegotiabilityIndicator extends StatelessWidget {
  NegotiabilityIndicator(
      {super.key, required this.negotiability, required this.state});
  final int state;
  final bool negotiability;

  Color soldcolor = Color.fromARGB(255, 255, 87, 82);
  Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
  Color availablecolor = Color.fromARGB(255, 0, 201, 56);
  @override
  Widget build(BuildContext context) {
    return (state != 0)
        ? Container()
        : Container(
            height: 23.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: InkWell(
                  onTap: () {
                    //Snackbar to show negotiability
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            negotiability ? 'Negotiable' : 'Not Negotiable'),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: negotiability ? availablecolor : soldcolor,
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                )),
          );
  }
}
