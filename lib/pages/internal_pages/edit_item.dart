// ignore_for_file: must_be_immutable

import 'package:buyandsell/auth/firebase_options.dart';
// import 'package:buyandsell/auth/firestorage.dart';
import 'package:buyandsell/widgets/horiz_div.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditItem extends StatefulWidget {
  EditItem({super.key, required this.mode, required this.dataMap});

  final Map dataMap;
  final String mode;

  //Text Controllers____________________________________________________________
  // Controllers for Editable Fields, See Readme for more info
  TextEditingController categoryControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  TextEditingController item_countControl = TextEditingController();
  TextEditingController locationControl = TextEditingController();
  TextEditingController negotiabilityControl = TextEditingController();
  TextEditingController other_priceControl = TextEditingController();
  TextEditingController other_storeControl = TextEditingController();
  TextEditingController spControl = TextEditingController();
  TextEditingController stateControl = TextEditingController();
  TextEditingController store_linkControl = TextEditingController();
//______________________________________________________________________________

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  @override
  Widget build(BuildContext context) {
//__________________________________________________________________________
    // double sidePad = 20.0;
    double verticalPad = 10.0;
    late Color bgColor;
    late Color textColor;
    late Color focusColor;
    late Color borderColor;
    // late Color totalBorderColor;
    // late Color buttonColor;
    // late Color buttonTextColor;
    late Color buttonBorderColor;
    late Color iconColor;
    late Color labelColor;
    late Color dividerColor;
    late Color hintTextColor;
    late Color submitButtonColor;
    Color soldcolor = Color.fromARGB(255, 255, 87, 82);
    Color bookedcolor = Color.fromARGB(255, 254, 189, 47);
    Color availablecolor = Color.fromARGB(255, 0, 201, 56);

    double borderRadius = 17.0;
    double focusBorderRadius = 15.0;
    // double totalBorderRadius = 20.0;
    double focusBorderWidth = 2.0;
    // double totalBorderWidth = 2.0;
    // double buttonBorderRadius = 17.0;
    double buttonBorderWidth = 2.0;

    void getTheme() {
      if (widget.mode == 'dark') {
        bgColor = Color.fromARGB(221, 13, 13, 40);
        textColor = Color.fromARGB(255, 255, 255, 255);
        focusColor = Color.fromARGB(255, 138, 181, 255);
        // totalBorderColor = Color.fromARGB(255, 159, 199, 255);
        borderColor = Color.fromARGB(255, 85, 126, 183);
        // buttonColor = Color.fromARGB(255, 255, 255, 255);
        buttonBorderColor = Color.fromARGB(255, 0, 189, 145);
        // buttonTextColor = Color.fromARGB(255, 255, 255, 255);
        iconColor = Color.fromARGB(255, 215, 215, 215);
        labelColor = Color.fromARGB(255, 25, 25, 61);
        dividerColor = Color.fromARGB(221, 37, 37, 82);
        hintTextColor = Color.fromARGB(255, 43, 43, 83);
        submitButtonColor = Color.fromARGB(255, 0, 127, 108);
      } else {
        bgColor = Color.fromARGB(255, 255, 255, 255);
        textColor = Color.fromARGB(255, 0, 13, 32);
        focusColor = Color.fromARGB(255, 44, 90, 171);
        // totalBorderColor = Color.fromARGB(255, 0, 35, 83);
        borderColor = Color.fromARGB(255, 60, 101, 163);
        // buttonColor = Color.fromARGB(255, 0, 0, 0);
        buttonBorderColor = Color.fromARGB(255, 0, 70, 54);
        // buttonTextColor = Color.fromARGB(255, 0, 13, 32);
        iconColor = Color.fromARGB(255, 23, 23, 23);
        labelColor = Color.fromARGB(255, 226, 251, 255);
        dividerColor = Color.fromARGB(255, 160, 160, 160);
        hintTextColor = Color.fromARGB(255, 148, 148, 148);
        submitButtonColor = Color.fromARGB(255, 0, 156, 119);
      }
    }

    //__________________________________________________________________________
    void onPressCancel(context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Discard Changes?'),
              content: Text('Are you sure you want to discard the changes?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Discard'),
                ),
              ],
            );
          });
    }

    String availabilityToString(int availability) {
      if (availability == 2) {
        return 'sold';
      } else if (availability == 1) {
        return 'booked';
      } else if (availability == 0) {
        return 'available';
      } else {
        return 'sold';
      }
    }

    String negotiabilityToString(bool negotiability) {
      if (negotiability) {
        return 'negotiable';
      } else {
        return 'non-negotiable';
      }
    }

    //__________________________________________________________________________
    void setControllers() {
      widget.categoryControl.text = widget.dataMap['category'];
      widget.descriptionControl.text = widget.dataMap['description'];
      widget.item_countControl.text = widget.dataMap['item_count'].toString();
      widget.locationControl.text = widget.dataMap['location'];
      widget.negotiabilityControl.text =
          negotiabilityToString(widget.dataMap['negotiability']);
      widget.other_priceControl.text =
          widget.dataMap['price']['other_price'] == -1
              ? ''
              : widget.dataMap['price']['other_price'].toString();
      widget.other_storeControl.text =
          widget.dataMap['price']['other_store'].toString();
      widget.spControl.text = widget.dataMap['price']['sp'].toString();
      widget.stateControl.text = availabilityToString(widget.dataMap['state']);
      widget.store_linkControl.text = widget.dataMap['store_link'];
    }

    void removeFromItemStack(String id) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ); //FIREBASE
      final database = FirebaseFirestore.instance; //FIREBASE
      database.settings = const Settings(
        persistenceEnabled: true,
      );

      CollectionReference itemStackCollection =
          await FirebaseFirestore.instance.collection('itemstack');
      itemStackCollection.doc('stack').get().then((value) {
        List itemStack = value['data'];
        //remove the map where id is equal to id
        itemStack.removeWhere((element) => element['id'] == id);
        itemStackCollection.doc('stack').update({'data': itemStack});
      });
    }

    //__________________________________________________________________________
    int getAvailability(String availability) {
      availability = availability.toLowerCase();
      if (availability == 'sold') {
        return 2;
      } else if (availability == 'booked') {
        return 1;
      } else if (availability == 'available') {
        return 0;
      } else {
        return 2; //default sold i.e. not available
      }
    }

    bool getNegotiability(String negotiability) {
      negotiability = negotiability.toLowerCase();
      if (negotiability == 'negotiable') {
        return true;
      } else if (negotiability == 'non-negotiable') {
        return false;
      } else {
        return false;
      }
    }

    //__________________________________________________________________________
    getTheme();
    setControllers();
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.mode == 'dark'
            ? const Color.fromARGB(255, 3, 14, 34)
            : const Color.fromARGB(255, 245, 251, 255),
        appBar: AppBar(
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
              onPressCancel(context);
            },
          ),
          backgroundColor: widget.mode == 'dark'
              ? const Color.fromARGB(255, 3, 14, 34)
              : const Color.fromARGB(255, 245, 251, 255),
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                    fontWeight: widget.mode == 'dark'
                        ? FontWeight.w500
                        : FontWeight.w600,
                    fontFamily: 'Nunito',
                  ),
                ),
                onPressed: () async {
                  bool _doSubmit = true;
                  //Mandatory fields checkings
                  //Mandatory fields are item_name, location, sp, availability or state, and any one image
                  if (widget.locationControl.text.trim() == '' ||
                      widget.spControl.text.trim() == '' ||
                      widget.stateControl.text.trim() == '') {
                    //Show snackbar that mandatory fields are not filled
                    _doSubmit = false;
                    SnackBar snackBar = const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                          'Mandatory fields are not filled. Please fill them.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  //Assigning values to variables
                  if (_doSubmit) {
                    //show loading dialog
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: bgColor,
                            title: Center(
                              child: Text('Listing Your Item',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: widget.mode == 'dark'
                                          ? FontWeight.w600
                                          : FontWeight.w700,
                                      color: textColor,
                                      fontFamily: 'Nunito')),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                CircularProgressIndicator(
                                  color: textColor,
                                  backgroundColor: bgColor,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Please wait...',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: widget.mode == 'dark'
                                            ? FontWeight.w600
                                            : FontWeight.w700,
                                        color: textColor,
                                        fontFamily: 'Nunito')),
                              ],
                            ),
                          );
                        });

                    String category = widget.categoryControl.text == ''
                        ? 'miscellaneous'
                        : widget.categoryControl.text;
                    if (widget.categoryControl.text == '') {
                      //show Snack bar that category set to miscellaneous
                      SnackBar snackBar = const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Category set to Miscellaneous'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    String description = widget.descriptionControl.text.trim();
                    int item_count;
                    try {
                      item_count =
                          int.parse(widget.item_countControl.text.trim());
                    } catch (e) {
                      item_count = 1;
                    }
                    String location = widget.locationControl.text.trim();
                    bool negotiability =
                        getNegotiability(widget.negotiabilityControl.text);
                    int sp;
                    try {
                      if (widget.spControl.text.trim() == '') {
                        sp = -1;
                      }
                      sp = int.parse(widget.spControl.text.trim());
                      if (sp < 0) {
                        sp = -1;
                      }
                    } catch (e) {
                      sp = -1;
                    }
                    String other_store =
                        widget.other_storeControl.text.trim().toLowerCase();
                    int other_price;
                    try {
                      if (widget.other_priceControl.text.trim() == '') {
                        other_price = -1;
                      }
                      other_price =
                          int.parse(widget.other_priceControl.text.trim());
                      if (other_price < 0) {
                        other_price = -1;
                      }
                    } catch (e) {
                      other_price = -1;
                    }
                    int state = getAvailability(widget.stateControl.text);
                    String store_link = widget.store_linkControl.text;

                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    ); //FIREBASE
                    final database = FirebaseFirestore.instance; //FIREBASE
                    database.settings = const Settings(
                      persistenceEnabled: true,
                    );
                    CollectionReference itemCollection = await FirebaseFirestore
                        .instance
                        .collection('itemlisting');

                    bool isSold = false;
                    if (state == 2) {
                      isSold = true;
                      removeFromItemStack(widget.dataMap['id']);
                      final storageRef = FirebaseStorage.instance.ref();
                      final userFolderRef = storageRef
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .child(widget.dataMap['id']);

                      try {
                        // List all files in the folder
                        final listResult = await userFolderRef.listAll();
                        for (final item in listResult.items) {
                          final fileRef =
                              FirebaseStorage.instance.ref(item.fullPath);
                          await fileRef.delete();
                          print('Deleted file: ${item.fullPath}');
                        }
                      } catch (e) {
                        print('Error deleting files: $e');
                      }
                    }

                    // open doc (dataMap['id']) and update the fields
                    {
                      itemCollection.doc(widget.dataMap['id']).update({
                        'category': category,
                        'description': description,
                        'item_count': item_count,
                        'location': location,
                        'negotiability': negotiability,
                        'price': {
                          'sp': sp,
                          'other_store': other_store,
                          'other_price': other_price,
                        },
                        'state': state,
                        'store_link': store_link,
                        'photo1url': isSold ? '' : widget.dataMap['photo1url'],
                        'photo2url': isSold ? '' : widget.dataMap['photo2url'],
                        'photo3url': isSold ? '' : widget.dataMap['photo3url'],
                        'photo4url': isSold ? '' : widget.dataMap['photo4url'],
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }).catchError((error) {
                        Navigator.pop(context);
                        SnackBar snackBar = const SnackBar(
                          backgroundColor: Colors.red,
                          content:
                              Text('Error updating item. Please try again.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  }
                },
              ),
            )
          ],
          title: Text('Edit Item',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: widget.mode == 'dark'
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 0, 8, 20),
                fontSize: 27.0,
                fontWeight: FontWeight.w800,
              )),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              //show loading dialog
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: bgColor,
                                      title: Center(
                                        child: Text('Updating Availability',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight:
                                                    widget.mode == 'dark'
                                                        ? FontWeight.w600
                                                        : FontWeight.w700,
                                                color: textColor,
                                                fontFamily: 'Nunito')),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CircularProgressIndicator(
                                            color: textColor,
                                            backgroundColor: bgColor,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text('Please wait...',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      widget.mode == 'dark'
                                                          ? FontWeight.w600
                                                          : FontWeight.w700,
                                                  color: textColor,
                                                  fontFamily: 'Nunito')),
                                        ],
                                      ),
                                    );
                                  });

                              await Firebase.initializeApp(
                                options: DefaultFirebaseOptions.currentPlatform,
                              ); //FIREBASE
                              final database =
                                  FirebaseFirestore.instance; //FIREBASE
                              database.settings = const Settings(
                                persistenceEnabled: true,
                              );
                              CollectionReference itemCollection =
                                  await FirebaseFirestore.instance
                                      .collection('itemlisting');

                              // open doc (dataMap['id']) and update the fields
                              itemCollection.doc(widget.dataMap['id']).update({
                                'state': 1,
                              }).then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }).catchError((error) {
                                Navigator.pop(context);
                                SnackBar snackBar = const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Error updating Availability. Please try again.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 13),
                              decoration: BoxDecoration(
                                color: bookedcolor,
                                border: Border.all(
                                  color: bookedcolor,
                                  width: buttonBorderWidth,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Item Booked',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 21,
                                    fontWeight: widget.mode == 'dark'
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              //show loading dialog
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: bgColor,
                                      title: Center(
                                        child: Text('Updating Availability',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight:
                                                    widget.mode == 'dark'
                                                        ? FontWeight.w600
                                                        : FontWeight.w700,
                                                color: textColor,
                                                fontFamily: 'Nunito')),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CircularProgressIndicator(
                                            color: textColor,
                                            backgroundColor: bgColor,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text('Please wait...',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      widget.mode == 'dark'
                                                          ? FontWeight.w600
                                                          : FontWeight.w700,
                                                  color: textColor,
                                                  fontFamily: 'Nunito')),
                                        ],
                                      ),
                                    );
                                  });

                              await Firebase.initializeApp(
                                options: DefaultFirebaseOptions.currentPlatform,
                              ); //FIREBASE
                              final database =
                                  FirebaseFirestore.instance; //FIREBASE
                              database.settings = const Settings(
                                persistenceEnabled: true,
                              );
                              removeFromItemStack(widget.dataMap['id']);
                              CollectionReference itemCollection =
                                  await FirebaseFirestore.instance
                                      .collection('itemlisting');

                              //delete files from storage, path is {FirebaseAuth.instance.currentUser.uid}/{dataMap['id']} folder
                              final storageRef = FirebaseStorage.instance.ref();
                              final userFolderRef = storageRef
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child(widget.dataMap['id']);

                              try {
                                // List all files in the folder
                                final listResult =
                                    await userFolderRef.listAll();
                                for (final item in listResult.items) {
                                  final fileRef = FirebaseStorage.instance
                                      .ref(item.fullPath);
                                  await fileRef.delete();
                                  print('Deleted file: ${item.fullPath}');
                                }
                              } catch (e) {
                                print('Error deleting files: $e');
                              }

                              itemCollection.doc(widget.dataMap['id']).update({
                                'state': 2,
                                'photo1url': '',
                                'photo2url': '',
                                'photo3url': '',
                                'photo4url': '',
                              }).then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }).catchError((error) {
                                Navigator.pop(context);
                                SnackBar snackBar = const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Error updating Availability. Please try again.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 13),
                              decoration: BoxDecoration(
                                color: soldcolor,
                                border: Border.all(
                                  color: soldcolor,
                                  width: buttonBorderWidth,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Item Sold',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 21,
                                    fontWeight: widget.mode == 'dark'
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text('Edit Item Details',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: verticalPad),
                              child: HorizontalDiv(
                                  dividerColor: dividerColor,
                                  width: 10,
                                  span: 1,
                                  thickness: 1.0)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: verticalPad),
                      child: TextField(
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.locationControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            focusColor: focusColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: focusColor, width: focusBorderWidth),
                              borderRadius:
                                  BorderRadius.circular(focusBorderRadius),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                              borderSide: BorderSide(
                                color: borderColor,
                                width: 1.0,
                              ),
                            ),
                            hintStyle: TextStyle(
                                color: hintTextColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            hintText: 'N block, Room-25',
                            labelText: 'Pickup Location*',
                            labelStyle: TextStyle(
                                color: textColor,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400),
                            suffixIcon: Icon(
                              Icons.location_on_rounded,
                              color: iconColor,
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 14),
                        //   child: Text('\u{20B9}',
                        //       style: TextStyle(
                        //         fontFamily: 'Nunito',
                        //         fontSize: 29,
                        //         fontWeight: FontWeight.w600,
                        //         color: widget.textColor,
                        //       )),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.spControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                                focusColor: focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: focusColor,
                                      width: focusBorderWidth),
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                prefixText: '\u{20B9} ',
                                prefixStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                labelText: 'Selling Price*',
                                labelStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 19, vertical: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: textColor, fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(labelColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            borderRadius))),
                              ),

                              width: 165,
                              controller: widget.categoryControl,

                              // hintText: 'books, decors etc.',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'books',
                                  label: 'Books',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'electronics',
                                  label: 'Electronics',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'decors',
                                  label: 'Decors',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'textile',
                                  label: 'Textile',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'cycle',
                                  label: 'Cycle',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'households',
                                  label: 'Households',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'sports',
                                  label: 'Sports',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'miscellaneous',
                                  label: 'Miscellaneous',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(labelColor),
                                    foregroundColor:
                                        WidgetStateProperty.all(textColor),
                                  ),
                                ),
                              ],
                              label: Text('Category',
                                  style: TextStyle(
                                      fontFamily: 'Nunito', color: textColor)),
                              // onSelected: ,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: textColor, fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            borderRadius))),
                              ),

                              width: 174.2,
                              controller: widget.negotiabilityControl,

                              // hintText: 'Negotiablity',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'negotiable',
                                  label: 'Negotiable',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        availablecolor), //Green color
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'nonnegotiable',
                                  label: 'Non-Negotiable',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor: WidgetStateProperty.all(
                                        soldcolor), //Red color
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                              ],
                              label: Text('Negotiablity',
                                  style: TextStyle(
                                      fontFamily: 'Nunito', color: textColor)),
                              // onSelected: ,
                            )),
                        Container(
                          // margin:
                          //     EdgeInsets.symmetric(horizontal: 19, vertical: 3),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: DropdownMenu(
                              trailingIcon: Icon(
                                Icons.arrow_drop_down,
                                color: iconColor,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                  borderSide: BorderSide(
                                    color: focusColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              textStyle: TextStyle(
                                  color: textColor, fontFamily: 'Nunito'),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(bgColor),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            borderRadius))),
                              ),

                              controller: widget.stateControl,
                              width: 166.2,
                              // hintText: 'Availability',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: 'sold',
                                  label: 'Sold',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(soldcolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'booked',
                                  label: 'Booked',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(bookedcolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                                DropdownMenuEntry(
                                  value: 'available',
                                  label: 'Available',
                                  style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(
                                        TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            fontFamily: 'Nunito')),
                                    backgroundColor:
                                        WidgetStateProperty.all(availablecolor),
                                    foregroundColor:
                                        WidgetStateProperty.all(Colors.black),
                                  ),
                                ),
                              ],
                              label: Text('Availability*',
                                  style: TextStyle(
                                      fontFamily: 'Nunito', color: textColor)),
                              // onSelected: ,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.item_countControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                                focusColor: focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: focusColor,
                                      width: focusBorderWidth),
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: '1',
                                labelText: 'Quantity',
                                labelStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.other_storeControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                                focusColor: focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: focusColor,
                                      width: focusBorderWidth),
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: 'Amazon, Flipkart ...',
                                labelText: 'Other Store',
                                labelStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.5, vertical: 21),
                          decoration: BoxDecoration(
                              color: dividerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: verticalPad),
                            child: TextField(
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400),
                              controller: widget.other_priceControl,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                                focusColor: focusColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: focusColor,
                                      width: focusBorderWidth),
                                  borderRadius:
                                      BorderRadius.circular(focusBorderRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: hintTextColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                prefixText: '\u{20B9} ',
                                prefixStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                hintText: '230',
                                labelText: 'Store Price',
                                labelStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400),
                                // suffixIcon:
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: verticalPad),
                      child: TextField(
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.store_linkControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          focusColor: focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: focusColor, width: focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(focusBorderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0,
                            ),
                          ),
                          hintStyle: TextStyle(
                              color: hintTextColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          hintText: 'eg : Amazon product link',
                          labelText: 'Store Link',
                          labelStyle: TextStyle(
                              color: textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          // suffixIcon: Icon(
                          //   Icons.email,
                          //   color: iconColor,
                          // )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: verticalPad),
                      child: TextField(
                        maxLines: 5,
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400),
                        controller: widget.descriptionControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          focusColor: focusColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: focusColor, width: focusBorderWidth),
                            borderRadius:
                                BorderRadius.circular(focusBorderRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                              color: textColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400),
                          // suffixIcon:
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              bool _doSubmit = true;
                              //Mandatory fields checkings
                              //Mandatory fields are item_name, location, sp, availability or state, and any one image
                              if (widget.locationControl.text.trim() == '' ||
                                  widget.spControl.text.trim() == '' ||
                                  widget.stateControl.text.trim() == '') {
                                //Show snackbar that mandatory fields are not filled
                                _doSubmit = false;
                                SnackBar snackBar = const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Mandatory fields are not filled. Please fill them.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }

                              //Assigning values to variables
                              if (_doSubmit) {
                                //show loading dialog
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: bgColor,
                                        title: Center(
                                          child: Text('Listing Your Item',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight:
                                                      widget.mode == 'dark'
                                                          ? FontWeight.w600
                                                          : FontWeight.w700,
                                                  color: textColor,
                                                  fontFamily: 'Nunito')),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CircularProgressIndicator(
                                              color: textColor,
                                              backgroundColor: bgColor,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text('Please wait...',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        widget.mode == 'dark'
                                                            ? FontWeight.w600
                                                            : FontWeight.w700,
                                                    color: textColor,
                                                    fontFamily: 'Nunito')),
                                          ],
                                        ),
                                      );
                                    });

                                String category =
                                    widget.categoryControl.text == ''
                                        ? 'miscellaneous'
                                        : widget.categoryControl.text;
                                if (widget.categoryControl.text == '') {
                                  //show Snack bar that category set to miscellaneous
                                  SnackBar snackBar = const SnackBar(
                                    backgroundColor: Colors.red,
                                    content:
                                        Text('Category set to Miscellaneous'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                String description =
                                    widget.descriptionControl.text.trim();
                                int item_count;
                                try {
                                  item_count = int.parse(
                                      widget.item_countControl.text.trim());
                                } catch (e) {
                                  item_count = 1;
                                }
                                String location =
                                    widget.locationControl.text.trim();
                                bool negotiability = getNegotiability(
                                    widget.negotiabilityControl.text);
                                int sp;
                                try {
                                  if (widget.spControl.text.trim() == '') {
                                    sp = -1;
                                  }
                                  sp = int.parse(widget.spControl.text.trim());
                                  if (sp < 0) {
                                    sp = -1;
                                  }
                                } catch (e) {
                                  sp = -1;
                                }
                                String other_store = widget
                                    .other_storeControl.text
                                    .trim()
                                    .toLowerCase();
                                int other_price;
                                try {
                                  if (widget.other_priceControl.text.trim() ==
                                      '') {
                                    other_price = -1;
                                  }
                                  other_price = int.parse(
                                      widget.other_priceControl.text.trim());
                                  if (other_price < 0) {
                                    other_price = -1;
                                  }
                                } catch (e) {
                                  other_price = -1;
                                }
                                int state =
                                    getAvailability(widget.stateControl.text);
                                String store_link =
                                    widget.store_linkControl.text;

                                await Firebase.initializeApp(
                                  options:
                                      DefaultFirebaseOptions.currentPlatform,
                                ); //FIREBASE
                                final database =
                                    FirebaseFirestore.instance; //FIREBASE
                                database.settings = const Settings(
                                  persistenceEnabled: true,
                                );
                                CollectionReference itemCollection =
                                    await FirebaseFirestore.instance
                                        .collection('itemlisting');

                                bool isSold = false;
                                if (state == 2) {
                                  isSold = true;
                                  removeFromItemStack(widget.dataMap['id']);

                                  final storageRef =
                                      FirebaseStorage.instance.ref();
                                  final userFolderRef = storageRef
                                      .child(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .child(widget.dataMap['id']);

                                  try {
                                    // List all files in the folder
                                    final listResult =
                                        await userFolderRef.listAll();
                                    for (final item in listResult.items) {
                                      final fileRef = FirebaseStorage.instance
                                          .ref(item.fullPath);
                                      await fileRef.delete();
                                      print('Deleted file: ${item.fullPath}');
                                    }
                                  } catch (e) {
                                    print('Error deleting files: $e');
                                  }
                                }

                                // open doc (dataMap['id']) and update the fields
                                {
                                  itemCollection
                                      .doc(widget.dataMap['id'])
                                      .update({
                                    'category': category,
                                    'description': description,
                                    'item_count': item_count,
                                    'location': location,
                                    'negotiability': negotiability,
                                    'price': {
                                      'sp': sp,
                                      'other_store': other_store,
                                      'other_price': other_price,
                                    },
                                    'state': state,
                                    'store_link': store_link,
                                    'photo1url': isSold
                                        ? ''
                                        : widget.dataMap['photo1url'],
                                    'photo2url': isSold
                                        ? ''
                                        : widget.dataMap['photo2url'],
                                    'photo3url': isSold
                                        ? ''
                                        : widget.dataMap['photo3url'],
                                    'photo4url': isSold
                                        ? ''
                                        : widget.dataMap['photo4url'],
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }).catchError((error) {
                                    Navigator.pop(context);
                                    SnackBar snackBar = const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Error updating item. Please try again.'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  });
                                }
                              }
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 13),
                              decoration: BoxDecoration(
                                color: submitButtonColor,
                                border: Border.all(
                                  color: buttonBorderColor,
                                  width: buttonBorderWidth,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 21,
                                    fontWeight: widget.mode == 'dark'
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
