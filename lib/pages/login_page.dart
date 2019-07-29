import 'package:appfirebase/classes/auth_firebase.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key,this.title,this.auth,this.onSignIn});
  final String title;
  final AuthFirebase auth;
  final VoidCallback onSignIn;
  _LoginPageState createState()=> new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  FormType formType=FormType.login;
  var email = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: formLogin(),
          ),
        ),
      ),
    );
  }

  List<Widget> formLogin(){
    return [
      padded(
        child: TextFormField(
          controller: email,
          decoration: InputDecoration(icon: Icon(Icons.person),labelText:'Correo',),
          autocorrect: false,
        )
      ),
      padded(
        child: TextFormField(
          controller: password,
          decoration: InputDecoration(icon: Icon(Icons.lock),labelText:'Contraseña',),
          autocorrect: false,
          obscureText: true,
        )
      ),
      Column(
        children: buttonWidgets(),
      )
    ];
  }

  List<Widget> buttonWidgets(){
    switch(formType){
      case FormType.login:
        return[styleButton('Iniciar Sesión',validateSubmit),
        FlatButton(
          child: Text("No tienes una cuenta? Registrate"),
          onPressed: ()=>updateFormType(FormType.register),
        )];
      case FormType.register:
        return[styleButton('Crear Cuenta',validateSubmit),
        FlatButton(
          child: Text("Iniciar Sesión"),
          onPressed: ()=>updateFormType(FormType.login),
        )];
    }
  }

  void updateFormType(FormType form){
    formKey.currentState.reset();
    setState(() {
     formType=form;
    });
  }
  //Aqui se agrega autenticacion con firebase
  void validateSubmit(){
    (formType == FormType.login) ? widget.auth.signIn(email.text, password.text):widget.auth.createUser(email.text, password.text);
    //Ejecuta updateAuthStatus de root que actualiza el estado
    widget.onSignIn();
  }

  Widget styleButton(String text,VoidCallback onPressed){
    return RaisedButton(onPressed: onPressed, 
    color: Colors.blue,
    textColor: Colors.white,
    child: Text(text),
    );
  }

  Widget padded({Widget child}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}