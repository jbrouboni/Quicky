import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicky/login_page_rest.dart';
import 'package:quicky/form_resto.dart';

class SignUpPageRest extends StatefulWidget {
  @override
  _SignUpPageRestState createState() => _SignUpPageRestState();
}

class _SignUpPageRestState extends State<SignUpPageRest> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;


  void signUp() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        AuthResult authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.trim(), password: _password);
        await Firestore.instance.collection("Restaurants").document(authResult.user.uid).setData({
          'adresse': '',
          'location' : new GeoPoint(0.0, 0.0),
          'nomRestaurant' : ''
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    //Home()), (Route<dynamic> route) => false);
                    FormRestaurant(authResult.user.uid)),
            (Route<dynamic> route) => false);
      } catch (e) {
        print(e);
      }
    }
  }

  void moveToLogIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginPageRest(), fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Inscription Restaurant'),
        )
        ,
        body: Stack(
            fit: StackFit.expand
            , children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/ff.jpg"),
            fit: BoxFit.fill,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
              children: <Widget>[
                SizedBox(height: 20,),
                Text('Rejoins la QuickTeam!',
                  style: TextStyle(color: Colors.redAccent, fontSize: 22),)
                , SizedBox(height: 20,),
                Text('Complète les informations suivantes',
                  style: TextStyle(color: Colors.white, fontSize: 17),),
                SizedBox(height: 40,),
                Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        inputDecorationTheme: new InputDecorationTheme(
                          hintStyle: new TextStyle(color: Colors.redAccent, fontSize: 20.0),
                          labelStyle:
                          new TextStyle(color: Colors.redAccent, fontSize: 20.0),
                        ))
                    ,isMaterialAppTheme: true,


                    child: Form(
                        key: formKey

                        , child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
//                        TextFormField(
//                          style: TextStyle(color: Colors.white,
//                          ),
//                          decoration: InputDecoration(labelText: 'Nom'),
//                          validator: (value) =>
//                          value.isEmpty
//                              ? "Entrez votre Nom de commerce"
//                              : null,
//                          onSaved: (value) => _nom = value,
//                        ),
//                        TextFormField(
//                          style: TextStyle(color: Colors.white,
//                          ),
//                          decoration: InputDecoration(labelText: 'adresse'),
//                          validator: (value) =>
//                          value.isEmpty
//                              ? "Entrez votre adresse"
//                              : null,
//                          onSaved: (value) => _adresse = value,
//                        ),
//                        TextFormField(
//                          style: TextStyle(color: Colors.white,
//                          ),
//                          decoration: InputDecoration(labelText: 'latitude'),
//                          validator: (value) =>
//                          value.isEmpty
//                              ? "Entrez votre latitude"
//                              : null,
//                          onSaved: (value) => _lat = value,
//                        ),
//                        TextFormField(
//                          decoration: InputDecoration(labelText: 'longitude'),
//                          validator: (value) =>
//                          value.isEmpty
//                              ? "Entrez votre longitude"
//                              : null,
//                          onSaved: (value) => _long = value,
//                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                          value.isEmpty
                              ? "Entrez votre adresse mail"
                              : null,
                          onSaved: (value) => _email = value,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Mot de passe'),
                          obscureText: true,
                          validator: (value) =>
                          value.isEmpty
                              ? "Entrez votre mot de passe"
                              : null,
                          onSaved: (value) => _password = value,
                        ),
                        SizedBox(height: 10,),
                        FlatButton(
                          child: Text(
                            'Inscription', style: TextStyle(fontSize: 20),),
                          onPressed: signUp,
                        ),
                        SizedBox(height: 10,),
                        FlatButton(onPressed: moveToLogIn,
                          child: Text(
                              'Connexion', style: TextStyle(fontSize: 20.0)),

                        ),
                      ],
                    )

                    )
                )]
          )
        ]
        )
    );
  }
}
