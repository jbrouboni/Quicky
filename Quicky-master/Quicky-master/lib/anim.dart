import 'dart:async';

import 'package:flutter/material.dart';
import 'welcome.dart';
class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return StartState();

  }
}
class StartState extends State<Splash>{
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  startTimer() async {
    var duration= Duration(seconds:9);
    return Timer(duration,route);
  }
  route()
  {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Welcome()));
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Container(
                    child:new Image( image: new AssetImage("assets/images/logoo.gif"),
                      fit:BoxFit.fill,height: 250,),
                  ),
                  Padding(padding:EdgeInsets.only(top: 10))
                  ,

                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 1,
                  )
                 , SizedBox(height: 30,)
                  ,Text(
                    "Bienvenue sur Quicky",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                    ),
                  ),
                ]
            )
        )
    );
  }
}