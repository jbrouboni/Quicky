import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'restaurant.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _nom;
  String _prenom;

  void signUp() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try{
        AuthResult authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.trim(), password: _password);
        await Firestore.instance.collection("Profile").document(authResult.user.uid).setData({
          'email': _email,
          'nom' : _nom,
          'prenom' : _prenom
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
            //Home()), (Route<dynamic> route) => false);
            Restaurant()), (Route<dynamic> route) => false);
      } catch (e) {
        print(e);
      }

    }
  }

  void moveToLogIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Inscription'),
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
                      TextFormField(
                        style: TextStyle(color: Colors.white,
                        ),
                        decoration: InputDecoration(labelText: 'Prenom'),
                        validator: (value) =>
                        value.isEmpty
                            ? "Entrez votre prenom"
                            : null,
                        onSaved: (value) => _prenom = value,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white,
                        ),
                        decoration: InputDecoration(labelText: 'Nom'),
                        validator: (value) =>
                        value.isEmpty
                            ? "Entrez votre nom"
                            : null,
                        onSaved: (value) => _nom = value,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white,
                      ),
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) =>
                        value.isEmpty
                            ? "Entrez votre adresse email"
                            : null,
                        onSaved: (value) => _email = value,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white,),
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

                      )
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

/*} Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:AssetImage("assets/images/rb.jpg",),
          )
        ),
        padding: EdgeInsets.all(16),
        child: Stack(),
        :Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value.isEmpty ? "Entrez un email" : null,
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (value) => value.isEmpty ? "Entrez un mot de passe" : null,
                  onSaved: (value) => _password = value,
                ),
                RaisedButton(
                  child: Text('Inscription', style: TextStyle(fontSize: 20),),
                  onPressed: signUp,
                ),
                FlatButton(onPressed: moveToLogIn,
                  child: Text('Connexion', style: TextStyle(fontSize: 20.0)),                )
              ],
            )
        ),
      ),
    );
  }*/

