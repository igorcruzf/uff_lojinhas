import 'package:cloud_firestore/cloud_firestore.dart';
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
                      new Image.network(shop.urlPhoto, fit: BoxFit.cover)
                  )
                  ,
                  new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Icon(Icons.location_on),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              shop.location,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 25.0, right: 10.0, top: 10.0, bottom: 10.0),
                            child: new Icon(Icons.cake),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
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

class _State extends State<HomePage> {
  Firestore db = Firestore.instance;
  List cardList = new List<Widget>();

  void getShops() {
    db.collection("lojas").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents
          .forEach((f) => cardList.add(new CardShop(Shop.mapToShop(f.data))));
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  //TODO excluir depois
  void testeDeCards() {
    for (var i = 0; i <= 2; i++) {
      Shop shop = new Shop();

      shop.location = "PV";
      shop.urlPhoto =
          "https://panificadoramadi.files.wordpress.com/2010/03/doces-de-festa-encomenda.jpg?w=584";
      shop.name = "Docinhos da Gi";
      shop.idOwner = i.toString();

      cardList.add(new CardShop(shop));
    }
  }

  @override
  Widget build(BuildContext context) {
    //Pega todas as lojinhas no banco
    getShops();

    //criando os cards cada um com um objeto de shop diferente // MOCK
    testeDeCards();

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
