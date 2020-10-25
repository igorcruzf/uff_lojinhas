import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class CardShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Image.network(
              'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg'),
          new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.thumb_up),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(
                      'Like',
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.comment),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text('Comments',
                        style: new TextStyle(fontSize: 18.0)),
                  )
                ],
              ))
        ],
      ),
    );
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

    List cards = new List.generate(20, (i) => new CardShop()).toList();

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
          children: cards,
        )));
  }
}
