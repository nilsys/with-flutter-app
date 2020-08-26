import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(MyApp(
    initialRoute: isLogged ? '/home' : '/',
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
        theme: ThemeData(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
