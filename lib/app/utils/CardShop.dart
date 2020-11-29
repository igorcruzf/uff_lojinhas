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
                fullscreenDialog: false,
                builder: (context) => ShowShopPage(loja: shop)),
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
                            child: Image.network(shop.urlPhoto,
                                fit: BoxFit.cover)),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(shop.name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF3F3E3E))))
                                ])),
                        Divider(),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(Icons.location_on, color: Colors.grey),
                                    Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(shop.campus,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    const Color(0xFFA6A29F))))
                                  ]),
                                  Row(children: <Widget>[
                                    Row(children: <Widget>[
                                      Icon(Icons.apartment, color: Colors.grey),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 12, left: 3),
                                          child: Text(shop.block,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xFFA6A29F))))
                                    ]),
                                    Row(children: <Widget>[
                                      Icon(Icons.stairs, color: Colors.grey),
                                      Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Text(shop.floor,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xFFA6A29F))))
                                    ])
                                  ])
                                ])),
                      ],
                    )))));
  }
}
