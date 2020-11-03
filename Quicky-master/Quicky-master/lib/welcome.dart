import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicky/sign_up_page.dart';
import 'package:quicky/sign_up_page_rest.dart';
import 'package:quicky/team.dart';
import 'restaurant.dart';
import 'login_page.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WelcomeState();
  }
}

class _WelcomeState extends State<Welcome>{
  void navigateToLogIn(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
  }
  Future signInAnon() async{
     await FirebaseAuth.instance.signInAnonymously();
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
     //Home()), (Route<dynamic> route) => false);
     Restaurant()), (Route<dynamic> route) => false);
  }
  void TeamPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Team(), fullscreenDialog: true ));
  }
  void navigateToSignUp(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => SignUpPage()));
  }
  void navigateToSignUpRest(){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => SignUpPageRest()));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
      Column(
      crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
      Padding(
      padding: EdgeInsets.only(top: 20.0),
      child:
      Container(
        child:
          Image.asset("assets/images/logo.jpg"),
            width: 150,
        height: 150,
      )


    ), SizedBox(height: 30,),
            RaisedButton(
              onPressed: navigateToLogIn,
              child: Text('Connexion'),
            ),
            SizedBox(height: 10,),
            RaisedButton(
                onPressed: navigateToSignUp,
                child: Text('Pas encore inscrit? Cliquez ici !'),
            ),
            SizedBox(height: 30,),
            RaisedButton(
              onPressed: navigateToSignUpRest,
              child: Text('Vous êtes un restaurant? Cliquez ici !'),
            ),
            SizedBox(height: 10,),
            RaisedButton(
              onPressed: signInAnon,
              child:Text(" Continuer en tant qu'invité "),
            ),
            SizedBox(height: 30,),
            Text(" Quicker than ever! ", style: TextStyle(color: Colors.red[400], fontSize: 18),),
            SizedBox(height: 28,),
            FlatButton(
              onPressed: TeamPage,
            child:Text("  by HexaQuick ", style: TextStyle(color: Colors.white, fontSize: 15),),)

            ]

      )
    ]
    )
    );
          /*

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          RaisedButton(
            onPressed: navigateToLogIn,
            child: Text('Connexion'),
          ),
          RaisedButton(
            onPressed: navigateToSignUp,
            child: Text('Inscription'),
          )
        ],
      ),

    )); */
  }
}
