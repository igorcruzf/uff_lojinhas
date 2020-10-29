import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    _getShops();
    super.initState();
  }

  //Acesso ao banco de dados
  Stream<QuerySnapshot> _getShops() {
    final stream = db.collection("shops").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  List<Widget> createCardList(List<DocumentSnapshot> list){

    List cardList = new List<Widget>();

    list.forEach((shop) => cardList.add(new CardShop(Shop.mapToShop(shop.data)))); //Cria um card por loja

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
                    Text("Carregando conversas"),
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
                      "Nenhuma lojinha cadastrada ainda :( " +
                          querySnapshot.documents.length.toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
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
                      children: createCardList(querySnapshot.documents.toList()), // Aqui que efetivamente é chamado os cards
                    )));
              }
          }
        });
  }
}
