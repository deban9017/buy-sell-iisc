// ignore_for_file: must_be_immutable

import 'package:buyandsell/functions/cardsperrow.dart';
import 'package:buyandsell/functions/homedataclass.dart';
// import 'package:buyandsell/widgets/itemlist.dart';
import 'package:buyandsell/widgets/wrapperitemcard.dart';
import 'package:flutter/material.dart';

class AllItems extends StatefulWidget {
  AllItems(
      {super.key,
      required this.mode,
      required this.dataList,
      required this.category,
      required this.heading});

  String heading;
  String category;
  final String mode;
  List dataList;
  List workingDataList = [];

  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  @override
  Widget build(BuildContext context) {
    List filterData(List dataList, String category) {
      List filteredData = [];
      if (category == 'all') {
        return dataList;
      }
      for (var item in dataList) {
        if (item['category'] == category) {
          filteredData.add(item);
        }
      }
      return filteredData;
    }

    widget.workingDataList = filterData(widget.dataList, widget.category);
    //implemented filter function
    //TODO: implement search function
    //TODO: implement sort function

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
        title: Text(widget.heading,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: widget.mode == 'dark'
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color.fromARGB(255, 0, 8, 20),
              fontSize: 27.0,
              fontWeight: FontWeight.w800,
            )),
      ),

      // body: Itemlist(mode: widget.mode, workingDataList: widget.workingDataList),
      body: (widget.workingDataList.isEmpty)
          ? Container(
              child: Center(
                child: Text(
                  'No items to display',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                      color: widget.mode == 'dark'
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 0, 8, 20),
                      fontFamily: 'Nunito'),
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 18.0,
                  childAspectRatio: 0.778,
                  crossAxisCount: getItemCardsPerRow()),
              itemBuilder: (context, index) {
                Map _item = widget.workingDataList[index];
                print(_item['id']);
                ItemCardData itemCardData = ItemCardData(dataMap: _item);
                itemCardData.assignData();
                return Container(
                  child: Wrapperitemcard(
                    mode: widget.mode,
                    dataMap: itemCardData.dataMap,
                  ),
                );
              },
              itemCount: widget.workingDataList.length),
    ));
  }
}
