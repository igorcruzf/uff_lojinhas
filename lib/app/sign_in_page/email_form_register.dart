import 'package:flutter/material.dart';

class EmailFormRegister extends StatefulWidget {
  @override
  _EmailFormRegisterState createState() => _EmailFormRegisterState();
}

class _EmailFormRegisterState extends State<EmailFormRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina de registro aqui", style: TextStyle(fontSize: 16),),
        actions: [
          FlatButton(
              child: Text("BACK", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
