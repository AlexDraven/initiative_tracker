import 'dart:io';

import 'package:flutter/material.dart';
import 'package:initiative_tracker/share_prefs/user_preferences.dart';
import 'package:provider/provider.dart';
import 'custom_http_overrides.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPrefs();
  // HttpOverrides.global = CustomHttpOverrides();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => CharactersService()),
      ChangeNotifierProvider(create: (_) => InitiativeWsService())
    ], child: const App());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DnD Initiative Tracker',
        initialRoute: CheckAuthScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          CharacterListScreen.routeName: (context) =>
              const CharacterListScreen(),
          CharacterScreen.routeName: (context) => const CharacterScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          CheckAuthScreen.routeName: (context) => const CheckAuthScreen(),
        },
        scaffoldMessengerKey: NotificationsService.messengerKey,
        theme: _mainTheme());
  }

  ThemeData _mainTheme() => ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.lightBlueAccent[50],
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Colors.indigoAccent,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.indigoAccent,
      ));
}
