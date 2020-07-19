//Developed by
//IT17006408 - A.S.H. Siribaddana

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'SignIn.dart';

//Splash screen widget appears during app load
//After the screen it navigates to login screen
class Startup extends StatefulWidget {
      Startup({Key key}) : super(key: key);
      @override
      _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
      
      @override
      Widget build(BuildContext context) {
        return SplashScreen(
          seconds: 8,
          backgroundColor: Colors.white,
          image: Image.asset("assets/map.gif"),
          loaderColor: Colors.white,
          photoSize: 200.0,
          navigateAfterSeconds: SignIn(),          
          title: Text(
            "Polestar - Envision your Marketplace",
            style: TextStyle(
              fontFamily: "Arial",
              color: Colors.blueGrey[200],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 14.0
            ),
          ),          
        );
      }
    }