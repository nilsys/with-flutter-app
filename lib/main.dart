import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:with_app/ui/style_guide.dart';
import './ui/router.dart';
import './locator.dart';
import './core/view_models/story_CRUDModel.dart';
import './core/view_models/user_CRUDModel.dart';
import './core/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Auth _auth = Auth();
  final bool isLogged = _auth.isLogged();
  setupLocator();
  runApp(StyleGuide(
    child: MyApp(
      initialRoute: isLogged ? '/home' : '/',
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
        ChangeNotifierProvider(create: (_) => locator<StoryCRUDModel>()),
        ChangeNotifierProvider(create: (_) => locator<UserCRUDModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        title: 'With',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: new Color.fromRGBO(31, 107, 137, 1),
          accentColor: Colors.cyan[600],

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
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 5.0),
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
          ),
        ),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
