import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/app/utils/validators.dart';
import 'package:uff_lojinhas/services/auth.dart';
import 'email_form_register.dart';

class EmailFormLogin extends StatefulWidget with EmailAndPasswordValidators {
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

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
  } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onChanged: (email) => _updateState(),
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "youremail@gmail.com",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
    );
  }

  TextField _passwordTextField(){
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      obscureText: true,
      onChanged: (password) => _updateState(),
      decoration: InputDecoration(
        enabled: !_isLoading,
        labelText: "Password",
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
    );
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;
    return [
      _emailTextField(),
      SizedBox(height: 16),
      _passwordTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Submit Login"),
      ),
      RaisedButton(
        onPressed: () => _registerWithEmail(context),
        child: Text("Register NOW")
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
