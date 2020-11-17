import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/app/utils/FilterButton.dart';
import 'package:uff_lojinhas/services/auth.dart';

import '../utils/CardShop.dart';
import '../model/Shop.dart';


class HomePage extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;

  @override
  void initState() {
    _getShops("Todos");
    super.initState();
  }

  //Acesso ao banco de dados
  Stream<QuerySnapshot> _getShops(campusFilter) {
    var stream;
    if(campusFilter=="Todos"){
      stream = db.collection("shops").snapshots();
    }
    else {
      stream = db.collection("shops").where("campus", isEqualTo: campusFilter).snapshots();
    }
    stream.listen((dados) {
      _controller.add(dados);
    });
  }
  

  List<Widget> createCardList(List<DocumentSnapshot> list) {
    List cardList = new List<Widget>();

    list.forEach((shop) => cardList
        .add(new CardShop(Shop.mapToShop(shop.data)))); //Cria um card por loja

    if(cardList.isEmpty){
      cardList.add(new Text(
          "Nenhuma lojinha encontrada =/",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),
      ));
    }

    return cardList;
  }

  //Função para deslogar
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
                    new Text(
                      "Carregando lojinhas...",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white
                      ),
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return new Text(
                  "Erro ao carregar as lojinhas",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                );
              } else {
                QuerySnapshot querySnapshot = snapshot.data;

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
                        child: Column(
                            children: ([
                              FilterButton(
                                  filter: (String filter) {
                                    setState(() => _getShops(filter));
                                }
                              ),
                      Expanded(
                          child: new ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: createCardList(querySnapshot.documents
                            .toList()), // Aqui que efetivamente é chamado os cards
                      ))
                    ]))));
              }
          }
        });
  }
}
