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
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 5 / 2,
                                child: Image.network(item.urlPhoto,
                                    fit: BoxFit.cover)),
                            Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Icon(Icons.shopping_bag_rounded,
                                            color: const Color(0xFF3F3E3E)),
                                        Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text(item.name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                    const Color(0xFF3F3E3E))))
                                      ]),
                                      Row(children: <Widget>[
                                        Icon(Icons.attach_money,
                                            color: const Color(0xFF3F3E3E)),
                                        Padding(
                                            padding: EdgeInsets.only(right: 3),
                                            child: Text(item.price,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                    const Color(0xFF3F3E3E))))
                                      ]),
                                    ])),
                          ],
                        ))))
          ]
        ));
  }
}
