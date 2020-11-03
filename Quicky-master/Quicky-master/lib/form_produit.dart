import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/liste_menu.dart';


class FormProduit extends StatefulWidget {
  final String idRestaurant;
  FormProduit(idRestaurant):this.idRestaurant = idRestaurant;

  @override
  _FormProduitState createState() => _FormProduitState();
}

class _FormProduitState extends State<FormProduit> {

  String _nomProduit,_nomTypeProduit,_imageUrl;
  double _prix;
  String value;
  bool nouveauType = false;

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Ajouter un nouveau produit'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'nom du nouveau produit'),
                  validator: (value) => value.isEmpty ? "Entrez un nom de produit" : null,
                  onSaved: (value) => _nomProduit = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'prix'),
                  onSaved: (value) => _prix = double.parse(value),
                  validator: (value){
                    if(value.isEmpty) return "Entrez un prix";
                    if(double.tryParse(value)==null) return "Entrez un prix valide";
                    return null;
                  }
                ),
                StreamBuilder(
                  stream: Firestore.instance.collection("Restaurants").document(widget.idRestaurant).collection("Menu").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _buildList(context, snapshot.data.documents);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'nom de la catégorie'),
                  validator: (value) => nouveauType&&value.isEmpty ? "Entrez un nom de catégorie" : null,
                  onSaved: (value) => _nomTypeProduit = value,
                  enabled: nouveauType,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'url d\'image'),
                  onSaved: (value) => _imageUrl = value,
                  enabled: nouveauType,
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

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return DropdownButton(
      items: _getTypes(snapshot),
      hint:new Text("Choissez un type pour le produit"),
      onChanged: (selectValue){
        setState(() {
          value = selectValue;
          if(value=="0")
            nouveauType = true;
          else
            nouveauType = false;
        });
      },
      value: value,
      elevation: 10,
      style: new TextStyle(
          color: Colors.blue,
          fontSize: 15
      ),
      iconSize: 30,
      underline: Container(height: 1,color: Colors.blue,),

    );
  }

  _updateData() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
    }
    if(!nouveauType) {
      await Firestore.instance.collection("Restaurants").document(
          widget.idRestaurant).collection("Menu").document(value).collection(
          "Produits").add({
        'nomProduit': _nomProduit,
        'prix': _prix
      });
    }else{
       DocumentReference newDocument = Firestore.instance.collection("Restaurants").document(
          widget.idRestaurant).collection("Menu").document();
       newDocument.setData({
        'nomTypeProduit': _nomTypeProduit,
        'imageUrl': _imageUrl
      });
       newDocument.collection("Produits").add({
         'nomProduit': _nomProduit,
         'prix': _prix
       });
    }
    Navigator.pop(context);
  }

  List<DropdownMenuItem<String>> _getTypes(List<DocumentSnapshot> snapshot){
    List<DropdownMenuItem<String>> res = snapshot.map((DocumentSnapshot documentSnapshot) {
      String nomTypeProduit = documentSnapshot['nomTypeProduit'];
      return DropdownMenuItem<String>(
        child: Text("$nomTypeProduit"),
        value: documentSnapshot.documentID,
      );
    }).toList();
    res.add(DropdownMenuItem(child: Text("nouveau type",style: TextStyle(color: value=="1"?Colors.red:Colors.grey),),value: "0",),);
    return res;
  }



}

