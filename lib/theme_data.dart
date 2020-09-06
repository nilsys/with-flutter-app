import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithTheme {
  static data(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: new Color.fromRGBO(31, 107, 137, 1),
      backgroundColor: Colors.white.withAlpha(40),
      fontFamily: 'Hind',
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
          .copyWith(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 16.0),
            headline4:
                GoogleFonts.satisfy(textStyle: TextStyle(fontSize: 20.0)),
            bodyText2:
                TextStyle(fontSize: 14.0, color: Colors.white, height: 1.5),
            bodyText1: TextStyle(fontSize: 14.0),
          )
          .apply(
            displayColor: Colors.tealAccent[200],
          ),
      cursorColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior
            .never, // this setting is not working - flutter bug try updating flutter package later on
        labelStyle:
            TextStyle(color: Colors.white.withAlpha(100), fontSize: 14.0),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusColor: Colors.white,
      ),
      buttonColor: Colors.tealAccent[200],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.tealAccent[200],
        height: 45,
      ),
      // iconTheme: IconThemeData(
      //   color: Theme.of(context).accentColor,
      // ),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //   style: ButtonStyle(
      //     border
      //   ),
      // ),
    );
  }
}
