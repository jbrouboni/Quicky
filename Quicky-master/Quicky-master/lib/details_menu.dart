import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/model/item_menu.dart';
import 'package:quicky/model/panier.dart';

class DetailsMenuPage extends StatefulWidget{

  String categorieId;
  PanierModel panier;
  DetailsMenuPage({this.categorieId, this.panier});

  @override
  State<StatefulWidget> createState() {
    return _DetailsMenuPageState();
  }
}

class _DetailsMenuPageState extends State<DetailsMenuPage>{


  PanierModel panier;
  
  @override
  void initState() {
    panier = widget.panier;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faîtes votre choix'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Restaurants").document("cJraGzuF74OHyrTfykeg").collection("Menu").document(widget.categorieId).collection("Produits").snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                //itemBuilder: (context, index) => _buildList(context, snapshot.data.documents[index], panier),
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
                        Text(panier.getNumberOfItemMenu(snapshot.data.documents[index].documentID).toString(), style: TextStyle(color: Colors.black)),
                        IconButton(
                          onPressed: (){
                            panier.addItemMenuToList(snapshot.data.documents[index].documentID, widget.categorieId, snapshot.data.documents[index]['prix']);
                            setState(() { });
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.orange,
                            size: 24.0,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            panier.retireItemMenu(snapshot.data.documents[index].documentID);
                            setState(() { });
                          },
                          icon: Icon(
                            Icons.remove,
                            color: Colors.orange,
                            size: 24.0,
                          ),
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

}

