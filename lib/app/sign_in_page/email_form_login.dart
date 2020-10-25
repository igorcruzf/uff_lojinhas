import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "email_form_register.dart";

class EmailFormLogin extends StatefulWidget {
  @override
  _EmailFormLoginState createState() => _EmailFormLoginState();
}

class _EmailFormLoginState extends State<EmailFormLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  _updateState() {
    print("email $_email, password: $_password");
    setState(() {});
  }

  void _registerWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => EmailFormRegister(),
      ),
    );
  }

  TextField _emailTextField(){
    return TextField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onChanged: (email) => _updateState(),
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "youremail@gmail.com"
      ),
    );
  }

  TextField _passwordTextField(){
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      onChanged: (password) => _updateState(),
      decoration: InputDecoration(
          labelText: "Password",
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      _emailTextField(),
      SizedBox(height: 16),
      _passwordTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: () {},
        child: Text("submit (#TODO login)"),
      ),
      RaisedButton(
        onPressed: () => _registerWithEmail(context),
        child: Text("Register NOW (#TODO registration)")
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      )
    );
  }
}
