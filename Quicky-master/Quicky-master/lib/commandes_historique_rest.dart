import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoriquePageRest extends StatefulWidget {
  @override
  _HistoriquePageRestState createState() => _HistoriquePageRestState();
}

class _HistoriquePageRestState extends State<HistoriquePageRest> {

  String userId = "";

  getCurrentUserId() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }
  getDateDisplay(Timestamp timestamp){
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(timestamp.toDate().toString()));
  }
  @override
  Widget build(BuildContext context) {
    return userId == "" ? Text("Loading") : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Historique'),
        actions: <Widget>[

        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection("Commandes").where("restaurantId",isEqualTo: userId).snapshots(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return Text('Loading..');
            } else {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[

                            Text("Prix"),
                            Text(snapshot.data.documents[index]["prix"].toString()),
                          ],

                        ),
                        Column(
                          children: <Widget>[
                            Text("Date"),
                            Text(getDateDisplay(snapshot.data.documents[index]["dateEnvoie"] as Timestamp) ),
                          ],

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
