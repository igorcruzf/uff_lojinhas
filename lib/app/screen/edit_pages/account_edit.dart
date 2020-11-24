import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';
import '../../utils/validators.dart';
import 'home_edit.dart';

class AccountEditPage extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void initState() {
    _getUser();
    super.initState();
  }

  TextEditingController _emailController;
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

  void _getUser() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      _emailController = TextEditingController(text: user.email);
    });
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final update = Provider.of<AuthBase>(context, listen: false);
      await update.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: false,
          builder: (context) => HomeEditPage(),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        child: Text("Atulizar conta"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualização da conta"),
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
