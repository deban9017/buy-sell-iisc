// ignore_for_file: must_be_immutable

import 'package:buyandsell/pages/internal_pages/all_category.dart';
import 'package:buyandsell/pages/internal_pages/all_items.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/widgets/category_card.dart';

class CategoriesRow extends StatefulWidget {
  CategoriesRow({super.key, required this.mode, required this.dataList});
  List dataList;
  String mode = 'dark'; // dark or light

  @override
  State<CategoriesRow> createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {
  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = const SizedBox(
      width: 16.0,
    );
    double dim = 100.0;
    String mode = widget.mode;
    double fontsize = 20.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            sizedBox,
            Expanded(
              child: Text(
                'Categories',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    color: mode == 'dark'
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 8, 20),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllCategory(mode: mode, dataList: widget.dataList);
                }));
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.blue,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 17.0,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
            sizedBox,
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                sizedBox,
                CategoryCard(
                    title: 'Books',
                    icon: const Icon(Icons.auto_stories_outlined),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Books',
                          mode: mode,
                          category: 'books',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Electronics',
                    icon: const Icon(Icons.tablet_android_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Electronics',
                          mode: mode,
                          category: 'electronics',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Decors',
                    icon: const Icon(Icons.spa_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Decors',
                          mode: mode,
                          category: 'decors',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Textile',
                    icon: const Icon(Icons.checkroom_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Textile',
                          mode: mode,
                          category: 'textile',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Cycle',
                    icon: const Icon(Icons.directions_bike_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Cycle',
                          mode: mode,
                          category: 'cycle',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Households',
                    icon: const Icon(Icons.house_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Households',
                          mode: mode,
                          category: 'households',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Sports',
                    icon: const Icon(Icons.sports_cricket_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Sports',
                          mode: mode,
                          category: 'sports',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
                CategoryCard(
                    title: 'Misc.',
                    icon: const Icon(Icons.category_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllItems(
                          heading: 'Miscellaneous',
                          mode: mode,
                          category: 'miscellaneous',
                          dataList: widget.dataList,
                        );
                      }));
                    },
                    dim: dim,
                    mode: mode,
                    fontsize: fontsize),
                sizedBox,
              ],
            )),
      ],
    );
  }
}
