import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uff_lojinhas/services/auth.dart';
import 'validators.dart';


class ShopFormRegister extends StatefulWidget with ShopFieldsValidators {
  @override
  _ShopFormRegisterState createState() => _ShopFormRegisterState();
}

class _ShopFormRegisterState extends State<ShopFormRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _campusController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _urlPhotoController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _campusFocusNode = FocusNode();
  final FocusNode _blockFocusNode = FocusNode();
  final FocusNode _floorFocusNode = FocusNode();
  final FocusNode _urlPhotoFocusNode = FocusNode();

  String get _name => _nameController.text;
  String get _campus => _campusController.text;
  String get _block => _blockController.text;
  String get _floor => _floorController.text;
  String get _urlPhoto => _urlPhotoController.text;
  bool _submitted = false;
  bool _isLoading = false;

  _updateState() {
    print("name $_name, campus: $_campus,block: $_block,floor: $_floor, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  /*void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }*/

  TextField _nameTextField() {
    bool showErrorText = !widget.nameValidator.isValid(_name) && _submitted;
    return TextField(
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,
      controller: _nameController,
      onChanged: (name) => _updateState(),
      decoration:
        InputDecoration(
          labelText: "Name",
          hintText: "Name of your shop",
          errorText: showErrorText ? widget.invalidNameErrorText : null,
          ),
    );
  }

  TextField _campusTextField() {
    bool showErrorText = _submitted && !widget.campusValidator.isValid(_campus);
    return TextField(
      focusNode: _campusFocusNode,
      controller: _campusController,
      obscureText: true,
      onChanged: (campus) => _updateState(),
      decoration: InputDecoration(
        labelText: "Campus",
        errorText: showErrorText ? widget.invalidCampusErrorText : null,
      ),
    );
  }

  TextField _blockTextField() {
    bool showErrorText = _submitted && !widget.blockValidator.isValid(_block);
    return TextField(
      focusNode: _blockFocusNode,
      controller: _blockController,
      obscureText: true,
      onChanged: (block) => _updateState(),
      decoration: InputDecoration(
        labelText: "Block",
        errorText: showErrorText ? widget.invalidBlockErrorText : null,
      ),
    );
  }

  TextField _floorTextField() {
    return TextField(
      focusNode: _floorFocusNode,
      controller: _floorController,
      obscureText: true,
      onChanged: (floor) => _updateState(),
      decoration: InputDecoration(
        labelText: "Floor",
      ),
    );
  }

  TextField _urlPhotoTextField() {
    return TextField(
      focusNode: _urlPhotoFocusNode,
      controller: _urlPhotoController,
      obscureText: true,
      onChanged: (urlPhoto) => _updateState(),
      decoration: InputDecoration(
        labelText: "Url of a image",
      ),
    );
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.nameValidator.isValid(_name) && widget.campusValidator.isValid(_campus) && widget.blockValidator.isValid(_block);
    return [
      _nameTextField(),
      SizedBox(height: 16),
      _campusTextField(),
      SizedBox(height: 32),
      _blockTextField(),
      SizedBox(height: 32),
      _floorTextField(),
      SizedBox(height: 32),
      _urlPhotoTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? null : null,
        child: Text("Create shop"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                )
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
