import 'package:cloud_firestore/cloud_firestore.dart';

class Item {

  String _idOwner;
  String _name;
  String _price;
  String _urlPhoto;

  Item();

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
