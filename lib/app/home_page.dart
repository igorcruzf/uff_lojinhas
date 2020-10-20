import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';

class HomePage extends StatelessWidget {


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
                  color: Colors.white
                ),
              )
          )
        ],
      ),
    );
  }
}
