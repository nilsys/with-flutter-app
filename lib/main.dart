import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:with_app/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'router.dart';
import './locator.dart';
import 'core/view_models/story.vm.dart';
import 'core/view_models/user.vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _auth = FirebaseAuth.instance;
  setupLocator();
  runApp(
    MyApp(
      initialRoute: _auth.currentUser != null ? '/home' : '/auth',
    ),
  );
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
        theme: WithTheme.data(context),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
