import 'package:flutter/material.dart';
import '../screen/edit_pages/item_edit.dart';
import '../model/Item.dart';

// ignore: must_be_immutable
class CardItemEdit extends StatelessWidget {
  Item item;
  String id;

  CardItemEdit(this.item, this.id);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: false,
                builder: (context) => ItemEditPage(produto: this.item, id: this.id)),
          );
        },
        child: Expanded(
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
                    )))));
  }
}
