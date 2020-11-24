import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_edit.dart';
import '../../utils/validators.dart';
import '../../model/Shop.dart';

class ShopEditPage extends StatefulWidget with ShopFieldsValidators {
  @override
  _ShopEditPageState createState() => _ShopEditPageState();
}

class _ShopEditPageState extends State<ShopEditPage> {
  TextEditingController _nameController;
  TextEditingController _blockController;
  TextEditingController _floorController;
  TextEditingController _urlPhotoController;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _blockFocusNode = FocusNode();
  final FocusNode _floorFocusNode = FocusNode();
  final FocusNode _urlPhotoFocusNode = FocusNode();

  String get _name => _nameController.text;
  String _campus;
  String get _block => _blockController.text;
  String get _floor => _floorController.text;
  String get _urlPhoto => _urlPhotoController.text;
  bool _submitted = false;
  bool _isLoading = false;

  Firestore db = Firestore.instance;
  Shop loja;
  String id;

  void initState() {
    _getShop();
    super.initState();
  }

  void _getShop() async {
    final FirebaseUser user = await auth.currentUser();

    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();

    CollectionReference colecao = db.collection("shops");
    QuerySnapshot collectionSnapshot = await colecao.getDocuments();

    templist = collectionSnapshot.documents;

    list = templist.map((DocumentSnapshot docSnapshot) {
      Map<String, dynamic> dado = docSnapshot.data;
      if (dado["idOwner"] == user.uid) {
        id = docSnapshot.documentID;
      }
      return dado;
    }).toList();

    list.forEach((dado) {
      if (dado["idOwner"] == user.uid) {
        setState(() {
          loja = Shop.mapToShop(dado);
        });
      }
    });

    setState(() {
      _nameController = TextEditingController(text: loja.name);
      _campus = loja.campus;
      _blockController = TextEditingController(text: loja.block);
      _floorController = TextEditingController(text: loja.floor);
      _urlPhotoController = TextEditingController(text: loja.urlPhoto);
    });
  }

  _updateState() {
    print(
        "name $_name, campus: $_campus,block: $_block,floor: $_floor, urlPhoto: $_urlPhoto");
    setState(() {});
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      CollectionReference shop = Firestore.instance.collection('shops');
      shop
          .document(id)
          .updateData({
            "name": _name,
            "campus": _campus,
            "block": _block,
            "floor": _floor,
            "urlPhoto": _urlPhoto
          })
          .then((value) => print("Shop Updated"))
          .catchError((error) => print("Failed to update shop: $error"));

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
        labelText: "Name",
        hintText: "Name of your shop",
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
        labelText: "Block",
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
        labelText: "Floor",
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
      _urlPhotoTextField(),
      SizedBox(height: 32),
      RaisedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text("Atualizar loja"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualização da loja"),
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
