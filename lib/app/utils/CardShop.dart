import 'package:flutter/material.dart';

import '../model/Shop.dart';
import '../screen/show_shop_page.dart';

// ignore: must_be_immutable
class CardShop extends StatelessWidget {
  Shop shop;

  CardShop(this.shop);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: false, builder: (context) => ShowShopPage(loja: shop)),
          );
        },
        child: new Container(
            width: 400.0,
            height: 290.0,
            child: new Card(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                      width: 400.0,
                      height: 200.0,
                      child:
                          new Image.network(shop.urlPhoto.toString(), fit: BoxFit.cover)),
                  new Padding(
                      padding: new EdgeInsets.all(15.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Icon(Icons.location_on),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Text(
                              shop.campus,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Text(
                              shop.block,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Text(
                              shop.floor,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 25.0,
                                right: 2.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: new Icon(Icons.cake),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(2.0),
                            child: new Text(shop.name,
                                style: new TextStyle(fontSize: 18.0)),
                          )
                        ],
                      ))
                ],
              ),
            )));
  }
}
