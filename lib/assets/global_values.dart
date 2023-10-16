import 'package:flutter/material.dart';

class GlobalValues {
  static ValueNotifier<bool> flagTheme = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagTask = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flaglogin = ValueNotifier<bool>(true);
  static int userType = 0;
  static String username = ''; // Agrega esta línea

  // Función para establecer el nombre de usuario
  static void setUsername(String name) {
    username = name;
  }
}
