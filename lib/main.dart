import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'onboarding_page.dart';
import 'tema_yonetici.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics: tüm yakalanmamış Flutter hatalarını yakala
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => TemaYonetici(),
      child: LokatistApp(onboardingDone: onboardingDone),
    ),
  );
}

class LokatistApp extends StatelessWidget {
  final bool onboardingDone;
  const LokatistApp({super.key, required this.onboardingDone});

  static final _analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaYonetici>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [observer],
      theme: ThemeData(
        brightness:
            tema.karanlikMod ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor:
            tema.karanlikMod ? const Color(0xFF0A0A0A) : Colors.white,
      ),
      home: onboardingDone
          ? const SplashScreen()
          : const OnboardingPage(),
    );
  }
}
