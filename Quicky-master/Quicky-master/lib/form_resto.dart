import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/commandes_historique_rest.dart';
import 'package:quicky/liste_menu.dart';
import 'package:quicky/welcome.dart';


class FormRestaurant extends StatefulWidget {
  final String idRestaurant;
  FormRestaurant(idRestaurant):this.idRestaurant = idRestaurant;

  @override
  _FormRestaurantState createState() => _FormRestaurantState();
}

class _FormRestaurantState extends State<FormRestaurant> {

  String _adresse,_nomRestaurant;
  double _latitude,_longitude;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Informations du restaurant'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder(
          stream: Firestore.instance.collection("Restaurants").document(widget.idRestaurant).snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return _buildList(context, snapshot.data);
            }
          },
        ),
      ),
    );
  }


  Widget _buildList(BuildContext context, DocumentSnapshot documentSnapshot) {

    return GestureDetector(
      child: Form(
        key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) => value.isEmpty ? "Entrez votre adresse" : null,
                onSaved: (value) => _adresse = value,
                initialValue: documentSnapshot["adresse"],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if(value.isEmpty) return "Entrez une latitude";
                  if(double.tryParse(value)==null) return "Entrez une latitude valide";
                  return null;
                },
                onSaved: (value) => _latitude = double.parse(value),
                initialValue: documentSnapshot["location"].latitude.toString(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if(value.isEmpty) return "Entrez une longitude";
                  if(double.tryParse(value)==null) return "Entrez une longitude valide";
                  return null;
                },
                onSaved: (value) => _longitude = double.parse(value),
                initialValue: documentSnapshot["location"].longitude.toString(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de votre restaurant'),
                validator: (value) => value.isEmpty ? "Entrez le nom de votre restaurant" : null,
                onSaved: (value) => _nomRestaurant = value,
                initialValue: documentSnapshot["nomRestaurant"],
              ),
              RaisedButton(
                child: Text('Actualiser les données', style: TextStyle(fontSize: 20),),
                onPressed: _updateData,
              ),
              FlatButton(
                child: Text('Modifier votre menu', style: TextStyle(fontSize: 16),),
                onPressed: navigateToFormMenu,
              ),
              FlatButton(
                child: Text('Historique des commandes', style: TextStyle(fontSize: 16),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new HistoriquePageRest()));
                },
              ),
              RaisedButton(
                child: Text('Deconnexion', style: TextStyle(fontSize: 20),),
                onPressed: (){ Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Welcome()), (Route<dynamic> route) => false);},
              ),
            ],
          )
      ),
    );

  }

  _updateData() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
    }
    await Firestore.instance.collection("Restaurants").document(widget.idRestaurant).updateData({
      'adresse': _adresse,
      'location' : new GeoPoint(_latitude, _longitude),
      'nomRestaurant': _nomRestaurant,
    });
  }

  void navigateToFormMenu(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => FormMenu(widget.idRestaurant), fullscreenDialog: true));
  }

}

