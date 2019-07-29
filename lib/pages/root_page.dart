import 'package:appfirebase/classes/auth_firebase.dart';
import 'package:appfirebase/pages/home_page.dart';
import 'package:appfirebase/pages/login_page.dart';
import 'package:flutter/cupertino.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key,this.authFirebase}):super(key:key);
  final AuthFirebase authFirebase;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  @override
  void initState() {
    widget.authFirebase.currentUser().then((userId){
      setState(() {
       authStatus=userId!=null ? AuthStatus.signedIn:AuthStatus.notSignedIn; 
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return LoginPage(title: "Login",auth: widget.authFirebase,onSignIn: ()=>updateAuthStatus(AuthStatus.signedIn),);
      case AuthStatus.signedIn:
        return HomePage(onSignIn: ()=>updateAuthStatus(AuthStatus.notSignedIn),authFirebase: widget.authFirebase,);
    }
    
  }
  void updateAuthStatus(AuthStatus auth){
    setState(() {
     authStatus = auth; 
    });
  }
}