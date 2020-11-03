import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeamState();
  }
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.teal,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor:Colors.teal ,
          title: Text('HexaQuick'),
        ),
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 200.0),
                        child: Image.asset("assets/images/hexaquick.png"),)
                  ]
              )
            ]
        )
    );
  }
}


