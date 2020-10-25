import "package:flutter/material.dart";
import 'package:uff_lojinhas/app/sign_in_page/email_form_login.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        //elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Card(
            color: Colors.grey[200],
            child: EmailFormLogin(),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

