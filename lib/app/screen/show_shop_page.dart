import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../whats_icons.dart';
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

  void _launchURL() async {
    String _link = "https://wa.me/" + widget.loja.number;
    print(_link);
    if (await canLaunch(_link)) {
      await launch(_link);
    } else {
      throw 'Could not launch $_link';
    }
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
              return Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Carregando loja...",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: 'sans',
                            decoration: TextDecoration.none,
                            color: Colors.indigo),
                      ),
                      Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.grey))
                    ],
                  ));
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Scaffold(
                    appBar: AppBar(
                        title: Text("Lojinhas da UFF"),
                        backgroundColor: Colors.indigo),
                    body: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Erro ao carregar dados.",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'sans',
                                  decoration: TextDecoration.none,
                                  color: Colors.indigo),
                            )
                          ],
                        )));
              } else {
                QuerySnapshot querySnapshot = snapshot.data;

                if (querySnapshot.documents.length == 0) {
                  return Scaffold(
                      appBar: AppBar(
                          title: Text(widget.loja.name),
                          backgroundColor: Colors.indigo),
                      body: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "A loja não possui itens.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        fontFamily: 'sans',
                                        decoration: TextDecoration.none,
                                        color: Colors.indigo),
                                  )
                                ])
                          ]));
                }
                return Scaffold(
                    appBar: AppBar(
                      title: Text(widget.loja.name),
                      backgroundColor: Colors.indigo,
                    ),
                    body: Container(
                        child: Column(children: <Widget>[
                      AspectRatio(
                          aspectRatio: 5 / 2,
                          child: Image.network(widget.loja.urlPhoto,
                              fit: BoxFit.cover)),
                      Container(
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Icon(Icons.location_on,
                                          color: const Color(0xFF3F3E3E)),
                                      Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Text(widget.loja.campus,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xFF3F3E3E))))
                                    ]),
                                    Row(children: <Widget>[
                                      Row(children: <Widget>[
                                        Icon(Icons.apartment,
                                            color: const Color(0xFF3F3E3E)),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: 12, left: 3),
                                            child: Text(
                                                "Bloco: ${widget.loja.block}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: const Color(
                                                        0xFF3F3E3E))))
                                      ]),
                                      Row(children: <Widget>[
                                        Icon(Icons.stairs,
                                            color: const Color(0xFF3F3E3E)),
                                        Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text(
                                                "Andar: ${widget.loja.floor}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: const Color(
                                                        0xFF3F3E3E))))
                                      ]),
                                      Row(children: <Widget>[
                                        Padding(
                                        padding:  EdgeInsets.only(left: 12),
                                        child:GestureDetector(
                                          onTap: _launchURL,
                                          child: Icon(Whats.whatsapp),
                                        )
                                      ),
                                      ])
                                    ])
                                  ]))),
                      Expanded(
                          child: new Container(
                              child: new ListView(
                        children:
                            createCardList(querySnapshot.documents.toList()),
                      ))),
                    ]) // Aqui que efetivamente é chamado os cards
                        ));
              }
          }
        });
  }
}
