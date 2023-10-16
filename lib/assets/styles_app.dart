import 'package:flutter/material.dart';

class StylesApp {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color.fromARGB(255, 192, 204, 83),
            ));
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color.fromARGB(255, 77, 84, 32),
            ));
  }
}
