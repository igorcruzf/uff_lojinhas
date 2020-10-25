import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/app/screen/sign_in_page/sign_in_page.dart';
import 'package:uff_lojinhas/services/auth.dart';
import 'home_page.dart';

/*
A ControlPage checa o fluxo de autenticacao, identificando mudancas no Stream
Dependendo do estado do Stream, ela renderiza a pagina de log in (SignInPage) ou
a pagina de feed do app (HomePage)
 */
/*
Provider e Streambuilder sao classes poderosas e sinceramente o funcionamento delas
ainda nao eh muito claro pra mim :(
https://pub.dev/packages/provider
 */

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage();
            }
            return HomePage();
          }else{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );
  }


}
