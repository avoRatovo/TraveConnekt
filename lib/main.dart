import 'package:flutter/material.dart';
import 'homepage.dart'; // Import du fichier home_page.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informations sur les billets',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF071777),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white, size: 28),
        ),
        primaryColor: Color(0xFF071777),
      ),
      home: HomePage(), // Appel de la page HomePage
    );
  }
}