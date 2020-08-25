import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './ui/router.dart';
import './locator.dart';
import './core/view_models/story_CRUDModel.dart';
import './core/view_models/user_CRUDModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<StoryCRUDModel>()),
        ChangeNotifierProvider(create: (_) => locator<UserCRUDModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        title: 'With',
        theme: ThemeData(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
