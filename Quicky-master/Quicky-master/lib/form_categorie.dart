import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/liste_menu.dart';


class FormCategorie extends StatefulWidget {
  final String idRestaurant;
  FormCategorie(idRestaurant):this.idRestaurant = idRestaurant;

  @override
  _FormCategorieState createState() => _FormCategorieState();
}

class _FormCategorieState extends State<FormCategorie> {

  String _nomTypeProduit,_imageUrl;
  String value;

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Ajouter une nouvelle catégorie'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'nom de la catégorie'),
                  validator: (value) => value.isEmpty ? "Entrez un nom de catégorie" : null,
                  onSaved: (value) => _nomTypeProduit = value,
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'url d\'image'),
                    onSaved: (value) => _imageUrl = value,
                ),
                RaisedButton(
                  child: Text('soumettre', style: TextStyle(fontSize: 20),),
                  onPressed: _updateData,
                ),
              ],
            )
        ),
      ),
    );
  }

  _updateData() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
    }

    DocumentReference newDocument = Firestore.instance.collection("Restaurants").document(
        widget.idRestaurant).collection("Menu").document();
    newDocument.setData({
      'nomTypeProduit': _nomTypeProduit,
      'imageUrl': _imageUrl
    });
    navigateToFormMenu();
  }

  void navigateToFormMenu(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => FormMenu(widget.idRestaurant), fullscreenDialog: true));
  }
}

