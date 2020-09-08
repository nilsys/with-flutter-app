import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithTheme {
  static data(BuildContext context) {
    final Color accentColor = Colors.tealAccent[200];
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color.fromRGBO(31, 107, 137, 1), // deep blue
      primaryColorLight: Color.fromRGBO(105, 81, 174, 1), // bright purple
      backgroundColor: Color.fromRGBO(249, 248, 251, 1),
      accentColor: accentColor,
      fontFamily: 'Hind',
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
          .copyWith(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 16.0),
            headline4:
                GoogleFonts.satisfy(textStyle: TextStyle(fontSize: 20.0)),
            headline5: TextStyle(fontSize: 16.0),
            bodyText2:
                TextStyle(fontSize: 14.0, color: Colors.white, height: 1.5),
            bodyText1:
                TextStyle(fontSize: 14.0, color: Colors.black, height: 1.5),
          )
          .apply(
            displayColor: accentColor,
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
      buttonColor: accentColor,
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
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
