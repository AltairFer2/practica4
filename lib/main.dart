import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/user_model.dart';
import 'package:pmsn20232/routes.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();

  // Abre la base de datos
  final database = await AgendaDB().database;

  // Inserta el usuario si no existe
  if (database != null) {
    final username = 'altair';
    final userExists = await AgendaDB().userExists(username);
    if (!userExists) {
      await AgendaDB().insertUser(database);
    }
  }

  runApp(MyApp());
}

Future<void> initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;
  bool themePreference = prefs.getBool('themePreference') ??
      true; // Obtén la preferencia del tema o usa un valor predeterminado
  _isLoggedIn = rememberMe; // Actualiza _isLoggedIn en función de rememberMe
  GlobalValues.flaglogin.value = rememberMe;

  // Establece la preferencia de tema en GlobalValues
  GlobalValues.flagTheme.value = themePreference;
}

void setThemePreference(bool isDarkModeEnabled) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('themePreference', isDarkModeEnabled);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          setThemePreference(value);
          return MaterialApp(
              home: _isLoggedIn ? DashboardScreen() : LoginScreen(),
              routes: getRoutes(),
              theme: GlobalValues.flagTheme.value
                  ? StylesApp.darkTheme(context)
                  : StylesApp.lightTheme(context)
              /*routes: {
            '/dash' : (BuildContext context) => LoginScreen()
          },*/
              );
        });
  }
}
