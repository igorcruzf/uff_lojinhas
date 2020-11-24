import 'package:flutter/material.dart';
import 'account_edit.dart';
import 'items_edit.dart';
import 'shop_edit.dart';

class HomeEditPage extends StatelessWidget {

  void _editAccount(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => AccountEditPage()),
    );
  }

  void _editShop(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ShopEditPage()),
      );
  }

  void _editItems(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ItemsEditPage()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Página de edição")),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 330),
                  RaisedButton(
                    onPressed: () => _editShop(context),
                    child: Text("Editar sua loja"),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () => _editItems(context),
                    child: Text("Editar seus produtos"),
                  )
                ])));
  }
}
