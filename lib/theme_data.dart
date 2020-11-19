import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithTheme {
  static data(BuildContext context) {
    final Color accentColor = Color.fromRGBO(232, 163, 1, 1); // orange
    return ThemeData(
      // brightness: Brightness.dark,
      primaryColor: Color.fromRGBO(105, 81, 174, 1), // purple
      primaryColorDark: Color.fromRGBO(96, 67, 145, 1), // purple
      primaryColorLight: Color.fromRGBO(130, 93, 240, 1), // purple
      indicatorColor: Color.fromRGBO(255, 0, 0, 1),
      // primaryColorLight: Color.fromRGBO(105, 81, 174, 1), // bright purple
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      accentColor: accentColor,
      fontFamily: 'Hind',
      appBarTheme: AppBarTheme(),
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
          .copyWith(
            headline1: GoogleFonts.dmSerifDisplay(
                textStyle:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500)),
            headline2: GoogleFonts.dmSerifDisplay(
                textStyle:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),
            headline3: TextStyle(fontSize: 16.0),
            headline4: GoogleFonts.dmSerifDisplay(
                textStyle: TextStyle(fontSize: 20.0)),
            headline5: TextStyle(
              fontSize: 16.0,
            ),
            subtitle2: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black.withAlpha(100),
                    height: 1)),
            overline: GoogleFonts.dmSerifDisplay(
                textStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              height: 1.5,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1.0,
              decorationColor: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            )),
            bodyText1:
                TextStyle(fontSize: 14.0, color: Colors.black, height: 1.5),
            bodyText2:
                TextStyle(fontSize: 14.0, color: Colors.black, height: 1.5),
          )
          .apply(
            displayColor: Colors.black,
          ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
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
        height: 40,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),

          // this effects to FlatButton and RaisedButton
          // side: BorderSide(
          //   color: Colors.white, //Color of the border
          //   style: BorderStyle.solid, //Style of the border
          //   width: 2, //width of the border
          // ),
        ),
      ),
      // iconTheme: IconThemeData(
      //   color: Theme.of(context).accentColor,
      // ),
    );
  }
}
