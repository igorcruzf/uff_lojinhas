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
    item.urlPhoto =  data["urlPhoto"] != null || data["urlPhoto"] != "" ? data["urlPhoto"] : "https://firebasestorage.googleapis.com/v0/b/uff-lojinhas.appspot.com/o/images%2Fimages%2Fboloicone.png?alt=media&token=250c8039-4a6c-4e4f-b3d2-2f4e61fbb430";
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
