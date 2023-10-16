import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pmsn20232/assets/global_values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogged = false;
  bool _rememberMe = false;

  TextEditingController txtConUser = TextEditingController();
  TextEditingController txtConPass = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    final username = txtConUser.text;
    final password = txtConPass.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final user = await AgendaDB().getUser(username);
      if (user != null && user.password == password) {
        // Establece el nombre de usuario en GlobalValues
        GlobalValues.username = user.username;

        // Realiza una consulta para obtener el tipo de usuario
        final userType = await AgendaDB().getUserType(user.username);

        // Establece el tipo de usuario en GlobalValues
        GlobalValues.userType = userType;

        setState(() {
          _isLogged = true;
        });

        if (_rememberMe) {
          _saveRememberMePreference(true);
        }

        Navigator.pushNamed(context, '/dash');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error de autenticación'),
              content: Text(
                  'Credenciales incorrectas. Por favor, intenta de nuevo.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error de autenticación'),
            content:
                Text('Por favor, ingresa un usuario y contraseña válidos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToRegistration() {
    // Navegar a la pantalla de registro
    Navigator.pushNamed(context, '/register');
  }

  Future<void> _saveRememberMePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLogged)
              Column(
                children: [
                  Text('Has iniciado sesión correctamente.'),
                  // Aquí puedes mostrar otros elementos relacionados con la sesión iniciada
                ],
              )
            else
              Column(
                children: [
                  TextField(
                    controller: txtConUser,
                    decoration: InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: txtConPass,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Mantener sesión iniciada'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _login(); // Simula el inicio de sesión
                    },
                    child: Text('Iniciar Sesión'),
                  ),
                  TextButton(
                    onPressed: _navigateToRegistration,
                    child: Text('¿No te has registrado?'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
