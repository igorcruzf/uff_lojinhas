import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';
import 'app/control_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: "Lojinhas da UFF",
          theme: ThemeData(
            primarySwatch: Colors.indigo,
        ),
          home: ControlPage(),
      )
    );
  }

}