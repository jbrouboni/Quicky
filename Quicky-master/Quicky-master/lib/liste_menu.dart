import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/form_categorie.dart';
import 'package:quicky/details_produits.dart';

class FormMenu extends StatefulWidget{

  final String idRestaurant;
  FormMenu(idRestaurant):this.idRestaurant = idRestaurant;

  @override
  State<StatefulWidget> createState() {
    return _FormMenuState();
  }
}

class _FormMenuState extends State<FormMenu>{

  void navigateToFormCategorie(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => FormCategorie(widget.idRestaurant), fullscreenDialog: true));
  }

  void navigateToDetailsForm(categorieId){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => DetailsForm(widget.idRestaurant,categorieId), fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de catégories'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.black,
            ),
            onPressed: navigateToFormCategorie,
          )
        ],
      ),

      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Restaurants").document(widget.idRestaurant).collection("Menu").snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildList(context, snapshot.data.documents[index],),

              );
            }
          },
        ),

      ),
    );
  }


  Widget _buildList(BuildContext context, DocumentSnapshot documentSnapshot) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 15,
              child: ListTile(
                title: Text(documentSnapshot['nomTypeProduit'], style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold ),),

              ),
            ),
            Spacer(
              flex: 1,
            ),
            RaisedButton(
              child: Text('supprimer', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
              onPressed: () async {
                _alertDialog(documentSnapshot);
              },
              color: Colors.orange,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

            ),
            Spacer(
              flex: 1,
            ),
            RaisedButton(
              child: Text('détails', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
              onPressed: ()=>navigateToDetailsForm(documentSnapshot.documentID),
              color: Colors.orange,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                //padding: EdgeInsets.fromLTRB(0,0,0,0),
            ),

          ],
        ),
      ),
    );

  }

  _alertDialog (DocumentSnapshot documentSnapshot) async {
    var result= await  showDialog(
        context: context,
        builder:  (context)=>AlertDialog(
          title: Text('Message'),
          content: Text('Voulez vous supprimer cette catégorie?'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.pop(context,'0');
            }, child: Text('non')),

            FlatButton(onPressed: () async{
              await Firestore.instance.collection('Restaurants').document(widget.idRestaurant).collection('Menu').document(documentSnapshot.documentID).delete();
              Navigator.pop(context,'1');
            }, child: Text('oui'))
          ],
        ));
  }

}
