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
                      child:
                          new Image.network(item.urlPhoto, fit: BoxFit.cover)),
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
