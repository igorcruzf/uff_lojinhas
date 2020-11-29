import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/app/utils/FilterButton.dart';
import 'package:uff_lojinhas/app/utils/SendNotification.dart';
import 'package:uff_lojinhas/services/auth.dart';



import 'edit_pages/home_edit.dart';
import '../utils/CardShop.dart';
import '../model/Shop.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final SendNotification sendNotification = SendNotification();
  Firestore db = Firestore.instance;

  bool logged = false;

  @override
  void initState() {
    _getShops("Todos");
    _getProvider();
    registerNotification();
    configLocalNotification();
    super.initState();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.subscribeToTopic('notifications');
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
    }).catchError((err) {
    });


  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'br.uff.uff_lojinhas',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  //Acesso ao banco de dados
  void _getShops(campusFilter) {
    var stream;
    if (campusFilter == "Todos") {
      stream = db.collection("shops").snapshots();
    } else {
      stream = db
          .collection("shops")
          .where("campus", isEqualTo: campusFilter)
          .snapshots();
    }
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  void _getProvider() async {
    final FirebaseUser user = await auth.currentUser();
    if (user.providerData[0].providerId == "password" ||
        user.providerData[1].providerId == "password") {
      logged = true;
    }
  }

  List<Widget> createCardList(List<DocumentSnapshot> list) {
    List cardList = List<Widget>();

    list.forEach((shop) => cardList
        .add(CardShop(Shop.mapToShop(shop.data)))); //Cria um card por loja

    if (cardList.isEmpty) {
      cardList.add(Text(
        "Nenhuma lojinha encontrada =/",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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

  void _edit(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => HomeEditPage()),
    );
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
                        "Carregando...",
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
                return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Text(
                      "Erro ao carregar lojinhas.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'sans',
                          decoration: TextDecoration.none,
                          color: Colors.indigo),
                    ));
              } else {
                QuerySnapshot querySnapshot = snapshot.data;

                return Scaffold(
                    appBar: AppBar(
                        title: Text("Lojinhas da UFF"),
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
                              )),
                          if (logged)
                            FlatButton(
                                onPressed: () => _edit(context),
                                child: Text(
                                  "Editar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white),
                                ))
                        ]),
                    body: Container(
                        child: Column(
                            children: ([
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Filtro por campus:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: const Color(0xFF3F3E3E)),
                            ),
                            FilterButton(filter: (String filter) {
                              setState(() => _getShops(filter));
                            }),
                          ]),
                      Expanded(
                          child: ListView(
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
