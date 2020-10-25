import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';

import 'model/Shop.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class CardShop extends StatelessWidget {
  Shop shop;

  CardShop(this.shop);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          print("Card " + shop.idOwner);
        },
        child: new SizedBox(
            width: 200.0,
            height: 300.0,
            child: new Card(
              color: Colors.white70,
              child: new Column(
                children: <Widget>[
                  new Image.network(shop.urlPhoto),
                  new Padding(
                      padding: new EdgeInsets.all(7.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.all(7.0),
                            child: new Icon(Icons.location_on),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(7.0),
                            child: new Text(
                              shop.location,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 25.0, right: 7.0, top: 7.0, bottom: 7.0),
                            child: new Icon(Icons.cake),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(7.0),
                            child: new Text(shop.name,
                                style: new TextStyle(fontSize: 25.0)),
                          )
                        ],
                      ))
                ],
              ),
            )));
  }
}

class _State extends State<HomePage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Shop shop = new Shop();
    //
    // shop.location = "PV";
    // shop.urlPhoto =
    //     "https://panificadoramadi.files.wordpress.com/2010/03/doces-de-festa-encomenda.jpg?w=584";
    // shop.name = "Docinhos da Gi";
    // List cards = new List.generate(20, (i) => new CardShop(shop)).toList();

    //criando os cards cada um com um objeto de shop diferente
    List cardList = new List<Widget>();
    for (var i = 0; i <= 20; i++) {
      Shop shop = new Shop();

      shop.location = "PV";
      shop.urlPhoto =
          "https://panificadoramadi.files.wordpress.com/2010/03/doces-de-festa-encomenda.jpg?w=584";
      shop.name = "Docinhos da Gi";
      shop.idOwner = i.toString();

      cardList.add(new CardShop(shop));
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("Lojinhas da UFF(feed)"),
            backgroundColor: Colors.indigo,
            actions: <Widget>[
              FlatButton(
                  onPressed: () => _signOut(context),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white),
                  ))
            ]),
        body: new Container(
            child: new ListView(
          children: cardList,
        )));
  }
}
