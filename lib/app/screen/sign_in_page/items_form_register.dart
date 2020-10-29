import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'validators.dart';

class ItemsFormRegister extends StatefulWidget with ItemsFieldsValidators {
  @override
  _ItemsFormRegisterState createState() => _ItemsFormRegisterState();
}

class _ItemsFormRegisterState extends State<ItemsFormRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _urlPhotoController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _urlPhotoFocusNode = FocusNode();

  String get _name => _nameController.text;
  String get _price => _priceController.text;
  String get _urlPhoto => _urlPhotoController.text;
  bool _submitted = false;
  bool _isLoading = false;
  bool _finish = false;

  _updateState() {
    print("name $_name, price: $_price, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final FirebaseUser user = await auth.currentUser();
      CollectionReference item = Firestore.instance.collection('items');
      item.add({
        "idOwner": user.uid,
        "name": _name,
        "price": _price,
        "urlPhoto": _urlPhoto
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  TextField _nameTextField() {
    bool showErrorText = !widget.nameValidator.isValid(_name) && _submitted;
    return TextField(
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,
      controller: _nameController,
      onChanged: (name) => _updateState(),
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Name of your item",
        errorText: showErrorText ? widget.invalidNameErrorText : null,
      ),
    );
  }

  TextField _priceTextField() {
    bool showErrorText = _submitted && !widget.priceValidator.isValid(_price);
    return TextField(
      focusNode: _priceFocusNode,
      controller: _priceController,
      onChanged: (price) => _updateState(),
      decoration: InputDecoration(
        labelText: "Price",
        errorText: showErrorText ? widget.invalidPriceErrorText : null,
      ),
    );
  }

  TextField _urlPhotoTextField() {
    return TextField(
      focusNode: _urlPhotoFocusNode,
      controller: _urlPhotoController,
      onChanged: (urlPhoto) => _updateState(),
      decoration: InputDecoration(
        labelText: "Url of a image",
      ),
    );
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.nameValidator.isValid(_name) &&
        widget.priceValidator.isValid(_price);
    return [
      _nameTextField(),
      SizedBox(height: 16),
      _priceTextField(),
      SizedBox(height: 32),
      _urlPhotoTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Create more items"),
      ),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Finish registration"),
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
                )),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
