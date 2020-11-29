import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Item.dart';

// ignore: must_be_immutable
class CardItemRemove extends StatelessWidget {
  Item item;
  String id;

  CardItemRemove(this.item, this.id);

  Firestore db = Firestore.instance;

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Remover produto"),
                content: Text("Deseja remover esse produto?"),
                actions: <Widget>[
                  GestureDetector(
                    child: Text("Sim"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _remove();
                    },
                  ),
                  GestureDetector(
                    child: Text("Não"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  void _remove() {
    db.collection("items").document(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          _showAlert(context);
        },
        child: new Container(
            width: 400.0,
            height: 300.0,
            child: new Card(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                      width: 400.0,
                      height: 200.0,
                      child: new Image.network(item.urlPhoto.toString(),
                          fit: BoxFit.cover)),
                  new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 25.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: new Icon(Icons.cake),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(item.name,
                                style: new TextStyle(fontSize: 18.0)),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 25.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: new Icon(Icons.attach_money),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(item.price,
                                style: new TextStyle(fontSize: 18.0)),
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }
}
