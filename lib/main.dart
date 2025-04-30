import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobilep2/pages/home_page.dart';
import 'package:mobilep2/pages/stock_page.dart';
import 'pages/login_page.dart';
import 'api/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StockPage("AAPL"),
    );
  }
}
