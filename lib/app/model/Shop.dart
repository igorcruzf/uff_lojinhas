import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {

  String _idOwner;
  String _name;
  String _urlPhoto;
  String _location;

  static Shop mapToShop(Map<String, dynamic> data){
    Shop shop = new Shop();
    print(data);
    shop.idOwner = data["idOwner"];
    shop.name = data["name"];
    shop.location = data["location"];
    shop.urlPhoto =  data.containsKey("urlPhoto")? data["urlPhoto"] : "https://www.milliescookies.com/tco-images/unsafe/fit-in/769x386/center/middle/smart/filters:upscale():fill(white):sharpen(0.5,0.5,true)/https://www.milliescookies.com/static/uploads/2017/04/page-not-found.jpg";
    return shop;
  }

  save() async {
    Firestore db = Firestore.instance;

    await db.collection("lojas")
        .document( this.idOwner )
        .setData( this.toMap() );
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idOwner"         : this.idOwner,
      "name"            : this.name,
      "urlPhoto"        : this.urlPhoto,
      "location"        : this.location,
    };

    return map;

  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  String get idOwner => _idOwner;

  set idOwner(String value) {
    _idOwner = value;
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
