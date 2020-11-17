import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uff_lojinhas/app/screen/home_page.dart';
import 'home_page.dart';
import '../utils/CardItem.dart';
import '../model/Shop.dart';
import '../model/Item.dart';

class ShowShopPage extends StatefulWidget {
  final Shop loja;
  ShowShopPage({this.loja});
  _State createState() => _State();
}

class _State extends State<ShowShopPage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  //Acesso ao banco de dados
  void _getItems() {
    final stream = db
        .collection("items")
        .where("idOwner", isEqualTo: widget.loja.idOwner)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  List<Widget> createCardList(List<DocumentSnapshot> list) {
    List cardList = new List<Widget>();

    list.forEach((item) => cardList
        .add(new CardItem(Item.mapToItem(item.data)))); //Cria um card por item

    return cardList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("Carregando loja"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados!");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;

                if (querySnapshot.documents.length == 0) {
                  return Center(
                    child: Text(
                      "A loja não tem itens" +
                          querySnapshot.documents.length.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return Scaffold(
                    appBar: AppBar(
                        title: Text(widget.loja.name),
                        backgroundColor: Colors.indigo,
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: false,
                                        builder: (context) => HomePage())
                                );
                              },
                              child: Text(
                                "Voltar para o feed",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.white),
                              ))
                        ]),
                    body: new Container(
                        child: new Column(
                          children: <Widget>[
                            new SizedBox(
                      width: 400.0,
                      height: 200.0,
                      child:
                      new Image.network(widget.loja.urlPhoto, fit: BoxFit.cover)),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Icon(Icons.location_on),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              "Campus: "+widget.loja.campus,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              "Bloco: " + widget.loja.block,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              "Andar: " + widget.loja.floor,
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                            new Expanded(
                              child: new Container(
                                height: 200.0,
                                child: new ListView(
                                  children: createCardList(querySnapshot.documents.toList()),
                                )
                              )
                            ),
                          ]
                        ) // Aqui que efetivamente é chamado os cards
                    )
                );
              }
          }
        });
  }
}
