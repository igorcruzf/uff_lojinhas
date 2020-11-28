import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home_page.dart';
import '../../utils/validators.dart';

class ItemsFormRegister extends StatefulWidget with ItemsFieldsValidators {
  @override
  _ItemsFormRegisterState createState() => _ItemsFormRegisterState();
}

class _ItemsFormRegisterState extends State<ItemsFormRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  File _image;
  final picker = ImagePicker();

  String get _name => _nameController.text;
  String get _price => _priceController.text;
  String _urlPhoto;
  bool _submitted = false;
  bool _isLoading = false;

  _updateState() {
    print("name $_name, price: $_price, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  Future _chooseFile() async {
    await picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  Future _uploadFile() async {
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

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final FirebaseUser user = await auth.currentUser();
      CollectionReference item = Firestore.instance.collection('items');
      await _uploadFile();
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

  void _submitMore() async {
    _submit();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ItemsFormRegister(),
      ),
    );
  }

  void _submitFinal() async {
    _submit();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => HomePage(),
      ),
    );
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
        hintText: "Nome do seu item",
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
        onPressed: submitEnabled ? _submitMore : null,
        child: Text("Criar mais itens"),
      ),
      RaisedButton(
        onPressed: submitEnabled ? _submitFinal : null,
        child: Text("Finalizar cadastro"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de itens"),
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
