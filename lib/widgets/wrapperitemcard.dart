// ignore_for_file: must_be_immutable

import 'package:buyandsell/widgets/itemcard.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/functions/cardsperrow.dart';

class Wrapperitemcard extends StatefulWidget {
  Wrapperitemcard({super.key, required this.mode, required this.dataMap});

  // final String id;
  String mode = 'dark';
  // String title = 'Item Card';
  // String price = 'Price';
  // String imagepath = 'lib/Assets/Images/example1.png';
  // int state = 1;
  Map dataMap = {};

  @override
  State<Wrapperitemcard> createState() => _WrapperitemcardState();
}

class _WrapperitemcardState extends State<Wrapperitemcard> {
  @override
  Widget build(BuildContext context) {
    Itemcard itemCard =
        Itemcard(mode: widget.mode, cardsperrow: getItemCardsPerRow());

    return itemCard.itemCard(
      context,
      dataMap: widget.dataMap,
    );
  }
}

class Wrapperdummycard extends StatefulWidget {
  const Wrapperdummycard({super.key});

  @override
  State<Wrapperdummycard> createState() => _WrapperdummycardState();
}

class _WrapperdummycardState extends State<Wrapperdummycard> {
  @override
  Widget build(BuildContext context) {
    Itemcard itemCard =
        Itemcard(mode: 'dark', cardsperrow: getItemCardsPerRow());
    return itemCard.dummyCard(context);
  }
}
