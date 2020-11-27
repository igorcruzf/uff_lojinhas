import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  String _idOwner;
  String _name;
  String _urlPhoto;
  String _campus;
  String _block;
  String _floor;

  static Shop mapToShop(Map<String, dynamic> data) {
    Shop shop = new Shop();
    shop.idOwner = data["idOwner"];
    shop.name = data["name"];
    shop.campus = data["campus"];
    shop.block = data["block"];
    shop.floor = data["floor"];
    shop.urlPhoto = data["urlPhoto"] != null || data["urlPhoto"] != "" ? data["urlPhoto"] : "https://firebasestorage.googleapis.com/v0/b/uff-lojinhas.appspot.com/o/images%2Fimages%2Fboloicone.png?alt=media&token=250c8039-4a6c-4e4f-b3d2-2f4e61fbb430";
  
   return shop;
  }

  save() async {
    Firestore db = Firestore.instance;

    await db.collection("lojas").document(this.idOwner).setData(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idOwner": this.idOwner,
      "name": this.name,
      "urlPhoto": this.urlPhoto,
      "campus": this.campus,
      "block": this.block,
      "floor": this.floor,
    };

    return map;
  }

  String get campus => _campus;

  set campus(String value) {
    _campus = value;
  }

  String get block => _block;

  set block(String value) {
    _block = value;
  }

  String get floor => _floor;

  set floor(String value) {
    _floor = value;
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
