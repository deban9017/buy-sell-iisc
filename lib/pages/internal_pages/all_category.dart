// ignore_for_file: must_be_immutable

import 'package:buyandsell/pages/internal_pages/all_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/widgets/categorypagecards.dart';

//Set values of colors and other properties for the category card

class AllCategory extends StatefulWidget {
  AllCategory({super.key, required this.mode, required this.dataList});
  final String mode;
  List dataList;

  Color get color => mode == 'dark'
      ? Color.fromARGB(255, 3, 14, 34)
      : Color.fromARGB(255, 245, 251, 255);

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  @override
  Widget build(BuildContext context) {
//Functions_____________________________________________________________________
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

    double getVerticalPad() {
      double width = MediaQuery.of(context).size.width;
      double verticalPad = 14;
      if (width > 1400) {
        verticalPad = 28;
      } else if (width > 1200) {
        verticalPad = 27;
      } else if (width > 1000) {
        verticalPad = 23;
      } else if (width > 800) {
        verticalPad = 20;
      } else if (width > 600) {
        verticalPad = 15;
      } else if (width > 400) {
        verticalPad = 20;
      }
      return verticalPad;
    }

    double getHorizontalPad() {
      double width = MediaQuery.of(context).size.width;
      double horizontalPad = 10;
      if (width > 1400) {
        horizontalPad = 20;
      } else if (width > 1200) {
        horizontalPad = 18;
      } else if (width > 1000) {
        horizontalPad = 16;
      } else if (width > 800) {
        horizontalPad = 14;
      } else if (width > 600) {
        horizontalPad = 12;
      } else if (width > 400) {
        horizontalPad = 10;
      }
      return horizontalPad;
    }

//______________________________________________________________________________
    Categorycard categorycard =
        Categorycard(mode: widget.mode, cardsperrow: getCrossAxisCount());

    return SafeArea(
        child: Scaffold(
      backgroundColor: widget.mode == 'dark'
          ? Color.fromARGB(255, 3, 14, 34)
          : Color.fromARGB(255, 245, 251, 255),
      appBar: AppBar(
        backgroundColor: widget.mode == 'dark'
            ? Color.fromARGB(255, 3, 14, 34)
            : Color.fromARGB(255, 245, 251, 255),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            weight: 200,
            size: 24.0,
            color: widget.mode == 'dark'
                ? Color.fromARGB(255, 255, 255, 255)
                : Color.fromARGB(255, 0, 8, 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('All Categories',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: widget.mode == 'dark'
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color.fromARGB(255, 0, 8, 20),
              fontSize: 27.0,
              fontWeight: FontWeight.w800,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: getHorizontalPad(),
            right: getHorizontalPad(),
            top: getVerticalPad(),
            bottom: getVerticalPad()),
        child: Center(
          child: GridView.count(
            crossAxisSpacing: getHorizontalPad() * 0.85,
            mainAxisSpacing: getVerticalPad() * 0.7,
            crossAxisCount: getCrossAxisCount(),
            children: [
              categorycard.categoryCard(
                context,
                title: 'Books',
                icon: Icon(Icons.auto_stories_outlined),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllItems(
                      heading: 'Books',
                      mode: widget.mode,
                      category: 'books',
                      dataList: widget.dataList,
                    );
                  }));
                },
              ),
              categorycard.categoryCard(context,
                  title: 'Electronics',
                  icon: Icon(Icons.tablet_android_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Electronics',
                    mode: widget.mode,
                    category: 'electronics',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Decors',
                  icon: Icon(Icons.spa_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Decors',
                    mode: widget.mode,
                    category: 'decors',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Textile',
                  icon: Icon(Icons.checkroom_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Textile',
                    mode: widget.mode,
                    category: 'textile',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Cycle',
                  icon: Icon(Icons.directions_bike_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Cycle',
                    mode: widget.mode,
                    category: 'cycle',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Households',
                  icon: Icon(Icons.house_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Households',
                    mode: widget.mode,
                    category: 'households',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Sports',
                  icon: Icon(Icons.sports_cricket_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Sports',
                    mode: widget.mode,
                    category: 'sports',
                    dataList: widget.dataList,
                  );
                }));
              }),
              categorycard.categoryCard(context,
                  title: 'Misc.',
                  icon: Icon(Icons.category_rounded), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllItems(
                    heading: 'Miscellaneous',
                    mode: widget.mode,
                    category: 'miscellaneous',
                    dataList: widget.dataList,
                  );
                }));
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
