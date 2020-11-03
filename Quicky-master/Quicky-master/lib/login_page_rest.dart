import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicky/form_resto.dart';
import 'package:quicky/sign_up_page_rest.dart';

class LoginPageRest extends StatefulWidget {
  @override
  _LoginPageRestState createState() => _LoginPageRestState();
}

class _LoginPageRestState extends State<LoginPageRest> {
  @override
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  void signIn() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      try {
        AuthResult authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _email.trim(), password: _password);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
            //Home()), (Route<dynamic> route) => false);
            FormRestaurant(authResult.user.uid)), (Route<dynamic> route) => false);
      } catch (e) {
        print(e);
      }
    }
  }

    void moveToRegister() {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => SignUpPageRest(), fullscreenDialog: true));
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          title: Text('Connexion Restaurant'),
        ),
        body: Stack(
            fit: StackFit.expand
            , children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/pizza.jpg"),
            fit: BoxFit.fill,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image(image: new AssetImage("assets/images/logo.jpg"),
                  fit: BoxFit.fill, height: 100,)
                , new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        inputDecorationTheme: new InputDecorationTheme(
                          hintStyle: new TextStyle(
                              color: Colors.redAccent, fontSize: 20.0),
                          labelStyle:
                          new TextStyle(
                              color: Colors.redAccent, fontSize: 20.0),
                        ))
                    , isMaterialAppTheme: true,

                    child: Form(
                        key: formKey

                        , child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                          value.isEmpty
                              ? "Entrez votre adresse email"
                              : null,
                          onSaved: (value) => _email = value,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Mot de passe'),
                          obscureText: true,
                          validator: (value) =>
                          value.isEmpty
                              ? "Entrez votre mot de passe"
                              : null,
                          onSaved: (value) => _password = value,
                        ),
                        FlatButton(
                          child: Text('Se connecter', style: TextStyle(
                              fontSize: 20),),
                          onPressed: signIn,
                        ),
                        FlatButton(onPressed: moveToRegister,
                          child: Text('Créer un compte', style: TextStyle(
                              fontSize: 20.0)),
                        )
                      ],
                    )
                    )
                )
              ]
          )
        ]
        )


        ,);
    }

}





