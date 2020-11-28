import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';
import 'error_messages.dart';
import 'shop_form_register.dart';
import '../../utils/validators.dart';

class EmailFormRegister extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailFormRegisterState createState() => _EmailFormRegisterState();
}

class _EmailFormRegisterState extends State<EmailFormRegister> {
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

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: false,
          builder: (context) => ShopFormRegister(),
        ),
      );
    } on PlatformException catch (e) {
      _showAlert(context, errorMessagesRegister[e.code]);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlert(BuildContext context, String code) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Erro"),
            content: Text(code),
            actions: <Widget>[
              GestureDetector(
                child: Text("OK"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ]
        ));
  }

  TextField _emailTextField() {
    bool showErrorText = !widget.emailValidator.isValid(_email) && _submitted;
    return TextField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onChanged: (email) => _updateState(),
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "seuemail@gmail.com",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
    );
  }

  TextField _passwordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      onChanged: (password) => _updateState(),
      decoration: InputDecoration(
        labelText: "Senha",
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
      ),
    );
  }


  List<Widget> _buildChildren() {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    return [
      _emailTextField(),
      SizedBox(height: 16),
      _passwordTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Criar conta"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        //elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Card(
            color: Colors.grey[200],
            child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildChildren(),
                )),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
