class Homedataclass {
  Map data;
  Homedataclass({required this.data});

  List maptoList(Map data) {
    List list = [];
    data.forEach((key, value) {
      String id = key;
      Map itemdata = value;
      itemdata['id'] = id;
      list.add(itemdata);
    });
    return list;
  }

  //assign the data to the variables //TODO: create a function
  //call the function in the HOME class
  //data to be broken into separate variables
}

class ItemCardData {
  //Fetched data is {fB6p8HPXc95DiNhbUaVZ: {item_count: 4, photo3name: [userid+itemlistid+3], spare3: , description: I am selling something..., photo2name: [userid+itemlistid+2], photo2url: url2, contact_details: {whatsapp: 1234567890, phone: 1234567890, email: xyz@iisc.ac.in}, item_name: Origin, Dan Brown, photo4url: url4, photo3url: url3, userid: iisc email, spare2: , spare1: , condition: {used_condition: 1, used_for: 1.5}, photo4name: [userid+itemlistid+4], seller_name: give seller display name here, photo1url: url1, price: {other_store: Amazon, other_price: 200, cp: 300, sp: 150}, store_link: give amazon, flipkart url here, can be null, negotiability: true, photo1name: [userid+itemlistid+1], location: N block, room 12, state: 1, category: books}}
  ItemCardData({required this.dataMap});
  Map dataMap;

  //defining the variables
  String? time_of_listing;
  String? id;
  int? itemCount;
  String? photo3name;
  String? description;
  String? photo2name;
  String? photo2url;
  String? whatsapp;
  String? phone;
  String? email;
  String? itemName;
  String? photo4url;
  String? photo3url;
  String? userId;
  int? usedCondition;
  int? usedFor;
  String? photo4name;
  String? sellerName;
  String? photo1url;
  //Firebase giving int or double //single data type 'number' in firebase
  dynamic sp; // int or double
  dynamic cp; // int or double
  dynamic otherPrice; // int or double
  String? otherStore;
  String? storeLink; // Optional value
  bool? negotiability;
  String? photo1name;
  String? location;
  int? state;
  String? category;

  //Rule: get the data from home
  //Convert the data into a list within the home class
  //use GridView.builder to display the data using the list and the itemcard and assignData function

  //assign the data to the variables
  void assignData() {
    // time_of_listing = DateTime.now().toString(); //Assigned in the constructor
    time_of_listing = dataMap['time_of_listing'];
    id = dataMap['id'];
    itemCount = dataMap['item_count'];
    photo3name = dataMap['photo3name'];
    description = dataMap['description'];
    photo2name = dataMap['photo2name'];
    photo2url = dataMap['photo2url'];
    whatsapp = dataMap['contact_details']['whatsapp'];
    phone = dataMap['contact_details']['phone'];
    email = dataMap['contact_details']['email'];
    itemName = dataMap['item_name'];
    photo4url = dataMap['photo4url'];
    photo3url = dataMap['photo3url'];
    userId = dataMap['userid'];

    usedCondition = dataMap['condition']['used_condition'];
    usedFor = dataMap['condition']['used_for'];
    photo4name = dataMap['photo4name'];
    sellerName = dataMap['seller_name'];
    photo1url = dataMap['photo1url'];
    sp = dataMap['price']['sp'];
    cp = dataMap['price']['cp'];
    otherPrice = dataMap['price']['other_price'];
    otherStore = dataMap['price']['other_store'];
    storeLink = dataMap['store_link'];
    negotiability = dataMap['negotiability'];
    photo1name = dataMap['photo1name'];
    location = dataMap['location'];
    state = dataMap['state'];
    category = dataMap['category'];
  }
}
