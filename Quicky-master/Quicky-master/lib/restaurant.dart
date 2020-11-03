import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicky/generate_QRcode.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:quicky/welcome.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'commandes_historique.dart';
import 'home.dart';
import 'commandes_historique.dart';

class Restaurant extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RestaurantState();
  }
}

class _RestaurantState extends State<Restaurant>{
  String barcode;
  Future<DocumentSnapshot> getProfile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    print(uid);
    return Firestore.instance
        .collection('Profile')
        .document(uid)
        .get();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez un restaurant'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            onPressed: () {
              scanQr(context);
            },
          ),

          new IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GeneratorQR()));
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

      ),
    );
  }

  Future scanQr(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      print("扫描结果是： $barcode");
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => new Home(barcode)));
        return this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = 'permission denied';
        });
      } else {
        setState(() {
          return this.barcode = '$e';
        });
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

}