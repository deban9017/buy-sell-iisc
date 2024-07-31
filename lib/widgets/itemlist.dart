// import 'package:buyandsell/functions/cardsperrow.dart';
// import 'package:buyandsell/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/functions/homedataclass.dart';
import 'package:buyandsell/widgets/wrapperitemcard.dart';
// import 'package:buyandsell/widgets/itemcard.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class Itemlist extends StatefulWidget {
  Itemlist({super.key, required this.mode, required this.dataList});
  String mode = 'dark'; // dark or light
  List dataList = [];

  double columnGap = 18.0;

  //TODO: sort the data by date-time, since latest items are to be displayed

  @override
  State<Itemlist> createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  @override
  Widget build(BuildContext context) {
    // print('Data received in Itemlist______________ ${widget.dataList}');
    final columnGap = widget.columnGap;
    // SizedBox sizedBox = const SizedBox(
    //   width: 16.0,
    // );
    String mode = widget.mode;

    List<Widget> itemBuilder() {
      List<Widget> itemWidgets = [];
      // print(
      //     'Inside ItemBuilder Number of items in the list: ${widget.dataList.length}');

      for (var item in widget.dataList) {
        ItemCardData itemCardData = ItemCardData(dataMap: item);
        itemCardData.assignData();
        itemWidgets.add(
          Container(
            // height: 250,
            child: Wrapperitemcard(
              mode: mode,
              dataMap: item,
            ),
          ),
        );
      }
      // print('Number of items in the list: ${itemWidgets.length}');
      return itemWidgets;
    }

    List<Widget> rowBuilder(List<Widget> itemWidgets) {
      List<Widget> rowWidgets = [];
      // print(
      //     'Inside RowBuilder Number of items in the list: ${itemWidgets.length}');
      for (var i = 0; i < itemWidgets.length; i += 2) {
        rowWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              itemWidgets[i],
              (i + 1 < itemWidgets.length)
                  ? itemWidgets[i + 1]
                  : Expanded(child: Container()),
            ],
          ),
        );
      }

      return rowWidgets;
    }

    List<Widget> columnBuilder(List<Widget> rowWidgets) {
      List<Widget> columnWidgets = [];
      for (var i = 0; i < rowWidgets.length; i++) {
        columnWidgets.add(rowWidgets[i]);
        columnWidgets.add(SizedBox(
          height: columnGap,
        ));
      }
      return columnWidgets;
    }

    // print('Number of items in the datalist: ${widget.dataList.length}');
    // print('Data received in Itemlist______________ ${widget.dataList}');
    // print(widget.dataList.isEmpty);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          (widget.dataList.isEmpty == true)
              ? const SizedBox(
                  height: 210,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: columnBuilder(rowBuilder(itemBuilder())),
                ),
        ],
      ),
    );
  }
}
