import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'splash_screen.dart';
import 'tema_yonetici.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => TemaYonetici(),
      child: const LokatistApp(),
    ),
  );
}

class LokatistApp extends StatelessWidget {
  const LokatistApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaYonetici>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: tema.karanlikMod ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: tema.karanlikMod
            ? const Color(0xFF0A0A0A)
            : Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}