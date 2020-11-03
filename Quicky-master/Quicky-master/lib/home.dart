import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicky/login_page.dart';
import 'package:quicky/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quicky/model/panier.dart';
import 'package:quicky/service/payment.dart';
import 'cart.dart';
import 'commandes_historique.dart';
import 'details_menu.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:quicky/sign_up_page.dart';

class Home extends StatefulWidget{

  final String idRestaurant;
  Home(idRestaurant):this.idRestaurant = idRestaurant;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{

  PanierModel panier;

  resetPanier(){
    //panier = PanierModel();
  }

  Future<DocumentSnapshot> getProfile() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    print(uid);
    return Firestore.instance
        .collection('Profile')
        .document(uid)
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
    panier = PanierModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Composez votre commande'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              panier = PanierModel();
            },
          ),
          new IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => new Cart(panier: panier,resetPanier: resetPanier(),)));
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[

            FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return new UserAccountsDrawerHeader(
                  accountName: Text(snapshot.data.data == null ? "Mode invité" : snapshot.data.data['nom'] + " " +
                      snapshot.data.data['prenom']),
                  accountEmail: Text(snapshot.data.data == null ? "" : snapshot.data.data['email']),
                  currentAccountPicture: GestureDetector(
                    child: new CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Image.asset("assets/images/jav.png")
                      //Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.red
                  ),

                  );
                } else {
                  return new UserAccountsDrawerHeader(
                    accountName: Text( 'Mode invité '),
                    currentAccountPicture: GestureDetector(
                      child: new CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.grey
                    ),

                  );
                }


              }
              ),
             ListTile(
               title:Text('Home'),
             leading:Icon(Icons.home),
             ),
            InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new HistoriquePage()));
              } ,
              child: ListTile(
                title:Text('Mes commandes'),
                leading:Icon(Icons.credit_card),
              ),
            ),

              InkWell(
                onTap:(){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Welcome()), (Route<dynamic> route) => false);} ,

                child: ListTile(
                  title:Text('Deconnexion'),
                  leading:Icon(Icons.exit_to_app),

              ),
            )
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          //stream: Firestore.instance.collection("Restaurants").document("cJraGzuF74OHyrTfykeg").collection("Menu").snapshots(),
          stream: Firestore.instance.collection("Restaurants").document(widget.idRestaurant).collection("Menu").snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildList(context, snapshot.data.documents[index], panier),

              );
            }
          },
        ),

      ),
    );
  }
}

Widget _buildList(BuildContext context, DocumentSnapshot documentSnapshot, PanierModel panier) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => new DetailsMenuPage(categorieId: documentSnapshot.documentID,panier: panier,)));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.network( documentSnapshot['imageUrl'],
              fit: BoxFit.cover,
              height: 60,
              width: 60,
            ),
          ),
          Expanded(
            flex: 3,
            child: ListTile(
              title: Text(documentSnapshot['nomTypeProduit'], style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold ),),

            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.red,
            size: 24.0,
          ),

        ],
      ),
    ),
  );

}