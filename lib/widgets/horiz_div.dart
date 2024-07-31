import 'package:flutter/material.dart';


// ignore: must_be_immutable
class HorizontalDiv extends StatelessWidget {
  HorizontalDiv(
      {super.key,
      required this.dividerColor,
      required this.width,
      required this.span,
      required this.thickness});
  Color dividerColor;
  double width;
  double span;
  double thickness;
  @override
  Widget build(BuildContext context) {
    double getHorizontalMargin(double span) {
      double margin;
      double totalWidth = MediaQuery.of(context).size.width;
      margin = totalWidth * ((1 - span) / 2);
      return margin;
    }

    return Container(
      decoration: BoxDecoration(
        color: dividerColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: EdgeInsets.symmetric(
          vertical: width / 2, horizontal: getHorizontalMargin(span)),
      height: thickness,
      width: double.infinity,
    );
  }
}