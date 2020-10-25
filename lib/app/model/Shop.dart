import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {

  String _idOwner;
  String _name;
  String _urlPhoto;
  String _location;

  Shop();

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
