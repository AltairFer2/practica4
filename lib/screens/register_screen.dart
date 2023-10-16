import 'package:flutter/material.dart';
import 'package:pmsn20232/models/user_model.dart';
import 'package:pmsn20232/database/agenda_db.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController txtConUser = TextEditingController();
  TextEditingController txtConPass = TextEditingController();

  void _register() async {
    final username = txtConUser.text;
    final password = txtConPass.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final db = AgendaDB();
      final existingUser = await db.getUser(username);

      if (existingUser != null) {
        // El usuario ya existe, muestra un mensaje de error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error de registro'),
              content: Text(
                  'El usuario ya está registrado. Por favor, elige otro nombre de usuario.'),
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
      } else {
        // El usuario no existe, puedes proceder con el registro
        final user = UserModel(username: username, password: password);
        final result = await db.addUser(user);

        if (result != -1) {
          // Registro exitoso, muestra un mensaje de éxito
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Registro exitoso'),
                content: Text('El usuario ha sido registrado correctamente.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Puedes navegar a la pantalla de inicio de sesión si lo deseas
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Error al registrar
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error de registro'),
                content: Text('Hubo un error al registrar el usuario.'),
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
    } else {
      // Datos de registro incompletos
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Datos incompletos'),
            content: Text('Por favor, ingresa todos los campos.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: txtConUser,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: txtConPass,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
