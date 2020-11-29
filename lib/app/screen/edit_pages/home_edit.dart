import 'package:flutter/material.dart';
import 'items_edit.dart';
import 'shop_edit.dart';
import 'items_remove.dart';
import '../sign_in_page/items_form_register.dart';
import "../home_page.dart";

class HomeEditPage extends StatelessWidget {
  void _toHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => HomePage()),
    );
  }

  void _editShop(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => ShopEditPage()),
    );
  }

  void _editItems(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => ItemsEditPage()),
    );
  }

  void _registerItems(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => ItemsFormRegister()),
    );
  }

  void _removeItems(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: false, builder: (context) => ItemsRemovePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Página de edição"), actions: <Widget>[
          FlatButton(
              onPressed: () => _toHome(context),
              child: Text(
                "Home",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.white),
              ))
        ]),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 200),
                  RaisedButton(
                    onPressed: () => _editShop(context),
                    child: Text("Editar sua loja"),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () => _editItems(context),
                    child: Text("Editar seus produtos"),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () => _registerItems(context),
                    child: Text("Registrar mais produtos"),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () => _removeItems(context),
                    child: Text("Remover produtos"),
                  )
                ])));
  }
}
