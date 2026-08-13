import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCgzQj-l2smjxWVy4fuhx8Ju6c5K8_2BYY",
      authDomain: "furtivosxml.firebaseapp.com",
      projectId: "furtivosxml",
      storageBucket: "furtivosxml.firebasestorage.app",
      messagingSenderId: "313903258233",
      appId: "1:313903258233:android:8895d4f57c37b3b66192a8",
    ),
  );
  
  // Inicializar notificaciones
  await NotificationService().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Navales',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (opcional)
      ],
      locale: const Locale('es', 'ES'), // Establecer español como idioma por defecto
    );
  }
}
