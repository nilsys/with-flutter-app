import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:with_app/ui/style_guide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './ui/router.dart';
import './locator.dart';
import 'core/view_models/story.vm.dart';
import 'core/view_models/user.vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  setupLocator();
  runApp(StyleGuide(
    child: MyApp(
      initialRoute: _auth.currentUser != null ? '/home' : '/auth',
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<StoryVM>()),
        ChangeNotifierProvider(create: (_) => locator<UserVM>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        title: 'With',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: new Color.fromRGBO(31, 107, 137, 1),
          // accentColor: Colors.cyan[600],

          // Define the default font family.
          fontFamily: 'Hind',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0),
            bodyText1: TextStyle(fontSize: 24.0),
          ).apply(
            bodyColor: Colors.orange,
            displayColor: Colors.pink,
          ),
          cursorColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.fromLTRB(20, 18, 20, 18),
            floatingLabelBehavior: FloatingLabelBehavior
                .never, // this setting is not working - flutter bug try updating flutter package later on
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusColor: Colors.white,
          ),
          buttonColor: Colors.tealAccent[200],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.tealAccent[200].withAlpha(150),
          ),
          // outlinedButtonTheme: OutlinedButtonThemeData(
          //   style: ButtonStyle(
          //     border
          //   ),
          // ),
        ),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
