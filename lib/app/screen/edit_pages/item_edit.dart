import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/Item.dart';
import '../../model/Shop.dart';
import '../../utils/validators.dart';
import 'home_edit.dart';

class ItemEditPage extends StatefulWidget with ItemsFieldsValidators {
  @override
  final Item produto;
  final String id;
  ItemEditPage({this.produto, this.id});
  _ItemEditPageState createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  String get _name => _nameController.text;
  String get _price => _priceController.text;
  String _urlPhoto;
  bool _submitted = false;
  bool _isLoading = false;

  File _image;
  final picker = ImagePicker();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  Shop loja;

  @override
  void initState() {
    _getItem();
    super.initState();
  }

  _updateState() {
    setState(() {});
  }

  Future _chooseFile() async {
    await picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  Future _uploadFile() async {
    if(_image != null){
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      var dowurl = await storageReference.getDownloadURL();
      setState(() {
        _urlPhoto = dowurl;
      });
    }
  }

  void _getItem() {
    _nameController = TextEditingController(text: widget.produto.name);
    _priceController = TextEditingController(text: widget.produto.price);
    _urlPhoto = widget.produto.urlPhoto;
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final FirebaseUser user = await auth.currentUser();
      CollectionReference item = Firestore.instance.collection('items');
      await _uploadFile();
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

  RaisedButton _uploadPhotoField() {
    return RaisedButton(
      child: Text('Selecione uma imagem'),
      onPressed: _chooseFile,
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
      _uploadPhotoField(),
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
