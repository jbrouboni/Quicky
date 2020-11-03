import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quicky/service/payment.dart';

import 'model/item_menu.dart';
import 'model/panier.dart';

class Cart extends StatefulWidget {
  PanierModel panier;
  Function resetPanier;

  Cart({this.panier, this.resetPanier});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Votre commande à bien été pris en compte'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nous allons vous servir au plus vite.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  createCommande(String userId){

    try{
       Firestore.instance.collection("Commandes").add({
        'estTermine' : false,
         'numeroTable': 5,
        'dateEnvoie' : DateTime.now(),
         'prix': widget.panier.getPrix(),
         'restaurantId': 'cJraGzuF74OHyrTfykeg',
         'userId': userId,
         'menu': widget.panier.getMapMenu()
      });
    } catch(e){
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        //amount: widget.panier.getPrix(),
        amount: widget.panier.getPrix(),
        currency: 'USD'
    );
    await dialog.hide();

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Register commande + reset panier
    createCommande(user.uid);
    widget.resetPanier;
    _neverSatisfied();


    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(' Votre panier'),
        actions: <Widget>[

        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.panier.listItemMenu.length,
          itemBuilder: (context, index){
            return ItemMenuListItem(itemMenu: widget.panier.listItemMenu[index]);
          },
        ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text("Total:"),
              subtitle: Text(widget.panier.getPrix() + "€"),
            )),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  payViaNewCard(context);
                },
                child: Text(
                  "Terminé",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}



class ItemMenuListItem extends StatelessWidget {
  final ItemMenu itemMenu;
  ItemMenuListItem({this.itemMenu});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection("Restaurants").document("cJraGzuF74OHyrTfykeg").collection("Menu").document(itemMenu.idCategorie).collection("Produits").document(itemMenu.id).get(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Text('Loading');
        } else {
          return ListTile(
            title: Text(snapshot.data["nomProduit"]),
            subtitle: Text('prix unitaire: ' + itemMenu.prix.toString() + "€"),
            trailing: Text(itemMenu.number.toString()),
          );
        }
      },
    );
  }
}
