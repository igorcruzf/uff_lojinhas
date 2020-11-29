import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/CardItemRemove.dart';
import '../../model/Shop.dart';
import '../../model/Item.dart';

class ItemsRemovePage  extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<ItemsRemovePage > {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  Shop loja;

  @override
  void initState() {
    _getShop();
    super.initState();
  }

  void _getShop() async {
    try {
      final FirebaseUser user = await auth.currentUser();

      List<DocumentSnapshot> templist;
      List<Map<dynamic, dynamic>> list = new List();

      CollectionReference colecao = db.collection("shops");
      QuerySnapshot collectionSnapshot = await colecao.getDocuments();

      templist = collectionSnapshot.documents;

      list = templist.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data;
      }).toList();

      list.forEach((dado) {
        if (dado["idOwner"] == user.uid) {
          setState(() {
            loja = Shop.mapToShop(dado);
          });

          _getItems(loja);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //Acesso ao banco de dados
  void _getItems(Shop loja) {
    try {
      final stream = db
          .collection("items")
          .where("idOwner", isEqualTo: loja.idOwner)
          .snapshots();

      stream.listen((dados) {
        _controller.add(dados);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> createCardList(List<DocumentSnapshot> list) {
    List cardList = new List<Widget>();

    list.forEach((item) => cardList.add(new CardItemRemove(Item.mapToItem(item.data), item.documentID))); //Cria um card por item
    
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
                    Text("Carregando items"),
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
                      title: Text("Escolha o item a remover"),
                      backgroundColor: Colors.indigo,
                    ),
                    body: new Container(
                        child: new ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:
                          createCardList(querySnapshot.documents.toList()),
                    )));
              }
          }
        });
  }
}
