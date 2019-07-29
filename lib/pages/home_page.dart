import 'package:appfirebase/classes/auth_firebase.dart';
import 'package:appfirebase/widgets/listview_animal.dart';
import 'package:flutter/material.dart';

import 'animal_form_page.dart';

class HomePage extends StatelessWidget {

  HomePage({this.onSignIn,this.authFirebase});
  final VoidCallback onSignIn;
  final AuthFirebase authFirebase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: signOut,
            child: Text("Cerrar Sesión"),
          )
        ],
        title: Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>FormAnimal("Nuevo animal",null),
            ),
          );
        },
        shape: StadiumBorder(),
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, size: 20.0,),
      ),
      body: ListViewAnimal(context),
    );
  }

  void signOut(){
    authFirebase.signOut();
    //Actualizamos estado de variable con este metodo q viene de rootpage
    onSignIn();
  }
}