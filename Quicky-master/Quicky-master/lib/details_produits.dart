import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/form_produit.dart';

class DetailsForm extends StatefulWidget{
  final String restaurantId;
  final String categorieId;
  DetailsForm(restaurantId,categorieId):this.restaurantId = restaurantId,this.categorieId = categorieId;

  @override
  State<StatefulWidget> createState() {
    return _DetailsFormState();
  }
}

class _DetailsFormState extends State<DetailsForm>{

  @override
  void initState() {
    super.initState();
  }

  void navigateToFormProduit(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => FormProduit(widget.restaurantId), fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.black,
            ),
            onPressed: navigateToFormProduit,
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Restaurants").document(widget.restaurantId).collection("Menu").document(widget.categorieId).collection("Produits").snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(snapshot.data.documents[index]['nomProduit'], style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold ),),
                            subtitle: Text('prix: ' + snapshot.data.documents[index]['prix'].toString() + "€", style: TextStyle(color: Colors.orange),),
                          ),
                        ),
                        Spacer(),
                        RaisedButton(
                          child: Text('supprimer', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                          onPressed: ()  async{
                            _alertDialog(snapshot,index);
                          },
                          color: Colors.orange,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),

      ),
    );
  }

  _alertDialog (AsyncSnapshot snapshot,index) async {
    var result= await  showDialog(
        context: context,
        builder:  (context)=>AlertDialog(
          title: Text('Message'),
          content: Text('Voulez vous supprimer ce produit?'),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.pop(context,'0');
            }, child: Text('non')),

            FlatButton(onPressed: () async{
              await Firestore.instance.collection('Restaurants').document(widget.restaurantId).collection('Menu').document(widget.categorieId).collection('Produits').document(snapshot.data.documents[index].documentID).delete();
              Navigator.pop(context,'1');
            }, child: Text('oui'))
          ],
        ));
  }

}

