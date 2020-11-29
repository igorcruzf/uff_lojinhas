import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uff_lojinhas/app/utils/SendNotification.dart';
import 'items_form_register.dart';
import '../../utils/validators.dart';

class ShopFormRegister extends StatefulWidget with ShopFieldsValidators {
  @override
  _ShopFormRegisterState createState() => _ShopFormRegisterState();
}

class _ShopFormRegisterState extends State<ShopFormRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _blockFocusNode = FocusNode();
  final FocusNode _floorFocusNode = FocusNode();

  File _image;
  final picker = ImagePicker();

  String get _name => _nameController.text;
  String _campus;
  String get _block => _blockController.text;
  String get _floor => _floorController.text;
  String _urlPhoto;
  bool _submitted = false;
  bool _isLoading = false;

  _updateState() {
    print(
        "name $_name, campus: $_campus,block: $_block,floor: $_floor, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _campus = '';
  }

  Future _chooseFile() async {
    await picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = File(image.path);
      });
    });
  }

  Future _uploadFile() async {
    try{
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    var dowurl = await storageReference.getDownloadURL();
    setState(() {
      _urlPhoto = dowurl.toString();
    });
    } catch (err){
      print(err);
      return;
    }
  }

  void _submit() async {
    SendNotification sendNotification = SendNotification();
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final FirebaseUser user = await auth.currentUser();
      CollectionReference shop = Firestore.instance.collection('shops');
      await _uploadFile();
      shop.add({
        "idOwner": user.uid,
        "name": _name,
        "campus": _campus,
        "block": _block,
        "floor": _floor,
        "urlPhoto": _urlPhoto
      });
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: false,
          builder: (context) => ItemsFormRegister(),
        ),
      );
    } finally {
      sendNotification.sendMessage("Tem lojinha nova no pedaço, bora dar uma conferida?", "Lojinhas da UFF");
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
        hintText: "Nome da sua loja",
        errorText: showErrorText ? widget.invalidNameErrorText : null,
      ),
    );
  }

  Container _campusTextField() {
    return Container(
      padding: EdgeInsets.all(16),
      child: DropDownFormField(
        titleText: 'Campus',
        hintText: 'Selecione um campus',
        value: _campus,
        onChanged: (value) {
          setState(() {
            _campus = value;
          });
        },
        dataSource: [
          {
            "display": "Praia Vermelha",
            "value": "Praia Vermelha",
          },
          {
            "display": "Gragoatá",
            "value": "Gragoatá",
          },
          {
            "display": "Valonguinho",
            "value": "Valonguinho",
          },
          {
            "display": "Direito",
            "value": "Direito",
          },
        ],
        textField: 'display',
        valueField: 'value',
      ),
    );
  }

  TextField _blockTextField() {
    bool showErrorText = _submitted && !widget.blockValidator.isValid(_block);
    return TextField(
      focusNode: _blockFocusNode,
      controller: _blockController,
      onChanged: (block) => _updateState(),
      decoration: InputDecoration(
        labelText: "Bloco",
        errorText: showErrorText ? widget.invalidBlockErrorText : null,
      ),
    );
  }

  TextField _floorTextField() {
    return TextField(
      focusNode: _floorFocusNode,
      controller: _floorController,
      onChanged: (floor) => _updateState(),
      decoration: InputDecoration(
        labelText: "Andar",
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
        widget.campusValidator.isValid(_campus) &&
        widget.blockValidator.isValid(_block);
    return [
      _nameTextField(),
      SizedBox(height: 16),
      _campusTextField(),
      SizedBox(height: 32),
      _blockTextField(),
      SizedBox(height: 32),
      _floorTextField(),
      SizedBox(height: 32),
      _uploadPhotoField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Criar loja"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro da loja"),
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
