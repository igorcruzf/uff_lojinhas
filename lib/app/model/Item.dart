import 'package:cloud_firestore/cloud_firestore.dart';

class Item {

  String _idOwner;
  String _name;
  String _price;
  String _urlPhoto;

  Item();

  static Item mapToItem(Map<String, dynamic> data){
    Item item = new Item();
    item.idOwner = data["idOwner"];
    item.name = data["name"];
    item.price = data["price"];
    item.urlPhoto =  data.containsKey("urlPhoto")? data["urlPhoto"] : "https://www.milliescookies.com/tco-images/unsafe/fit-in/769x386/center/middle/smart/filters:upscale():fill(white):sharpen(0.5,0.5,true)/https://www.milliescookies.com/static/uploads/2017/04/page-not-found.jpg";
    return item;
  }

  save() async {
    Firestore db = Firestore.instance;

    await db.collection("item")
        .document( this.idOwner )
        .setData( this.toMap() );
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idOwner"         : this.idOwner,
      "name"            : this.name,
      "urlPhoto"        : this.urlPhoto,
      "price"           : this.price,
    };

    return map;

  }


  String get idOwner => _idOwner;

  set idOwner(String value) {
    _idOwner = value;
  }


  String get price => _price;

  set price(String price) {
    _price = price;
  }


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get urlPhoto => _urlPhoto;

  set urlPhoto(String value) {
    _urlPhoto = value;
  }
}
