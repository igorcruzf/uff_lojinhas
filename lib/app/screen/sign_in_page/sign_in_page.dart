import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';

import 'email_sign_in_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text("ERROR"),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {},
          )
        ],
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lojinhas da UFF(signInPage)")
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 330),
              RaisedButton(
                onPressed: () => _signInAnonymously(context),
                child: Text("Entrar como cliente"),
              ),
              SizedBox(height: 16),
              RaisedButton(
                onPressed: _isLoading ? null : () => _signInWithEmail(context),
                child: Text("Entrar como (Lojista??)"),
              )
            ]
        )
      )
    );
  }
}
