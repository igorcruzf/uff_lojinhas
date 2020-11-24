import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/Item.dart';
import '../../model/Shop.dart';
import '../home_page.dart';
import '../../utils/validators.dart';
import 'items_edit.dart';
import 'home_edit.dart';

class ItemEditPage extends StatefulWidget with ItemsFieldsValidators {
  @override
  final Item produto;
  final String id;
  ItemEditPage({this.produto, this.id});
  _ItemEditPageState createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  TextEditingController _nameController;
  TextEditingController _priceController;
  TextEditingController _urlPhotoController;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _urlPhotoFocusNode = FocusNode();

  String get _name => _nameController.text;
  String get _price => _priceController.text;
  String get _urlPhoto => _urlPhotoController.text;
  bool _submitted = false;
  bool _isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  Shop loja;

  @override
  void initState() {
    _getItem();
    super.initState();
  }

  _updateState() {
    print("name $_name, price: $_price, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  void _getItem() {
    _nameController = TextEditingController(text: widget.produto.name);
    _priceController = TextEditingController(text: widget.produto.price);
    _urlPhotoController = TextEditingController(text: widget.produto.urlPhoto);
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final FirebaseUser user = await auth.currentUser();
      CollectionReference item = Firestore.instance.collection('items');
      item
          .document(widget.id)
          .updateData({"name": _name, "price": _price, "urlPhoto": _urlPhoto})
          .then((value) => print("Item Updated"))
          .catchError((error) => print("Failed to update item: $error"));

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

  TextField _nameTextField() {
    bool showErrorText = !widget.nameValidator.isValid(_name) && _submitted;
    return TextField(
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,
      controller: _nameController,
      onChanged: (name) => _updateState(),
      decoration: InputDecoration(
        labelText: "Nome",
        hintText: "Nome",
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
        labelText: "Preço",
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
        labelText: "Url da imagem",
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
        child: Text("Atualizar item"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualização do item"),
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
