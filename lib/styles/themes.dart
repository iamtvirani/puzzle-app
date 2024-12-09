import 'package:flutter/material.dart';

ThemeData get darkTheme => ThemeData(
      scaffoldBackgroundColor: const Color(0xFF333333),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFe6e6e6)),
        displayMedium: TextStyle(color: Color(0xFFe6e6e6)),
        displaySmall: TextStyle(color: Color(0xFFe6e6e6)),
        bodyLarge: TextStyle(color: Color(0xFFe6e6e6)),
        titleMedium: TextStyle(color: Color(0xFFe6e6e6)),
      ),
      cardColor: const Color(0xFF4d4d4d),
      colorSchemeSeed: const Color(0xFF333333),
      // backgroundColor: const Color(0xFF333333),
      iconTheme: const IconThemeData(
        color: Color(0xFFe6e6e6),
        opacity: 7.0,
      ),
    );

ThemeData get normalTheme => ThemeData(
    scaffoldBackgroundColor: const Color(0xFFd9d9d9),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF333333)),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFFFFFFF),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Color(0xFF8c8c8c)
    // backgroundColor: const Color(0xFF8c8c8c),
    );

ThemeData get yellow => ThemeData(
    scaffoldBackgroundColor: Colors.yellow.shade100,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF333333)),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF333333),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Colors.yellow

    // backgroundColor: Colors.yellow,
    );

ThemeData get red => ThemeData(
    scaffoldBackgroundColor: Colors.red.shade100,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF000000 )),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF333333),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Colors.red
    // backgroundColor: Colors.red,
    );

ThemeData get green => ThemeData(
    scaffoldBackgroundColor: Colors.green.shade100,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF333333)),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF333333),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Colors.green

    // backgroundColor: Colors.green,
    );

ThemeData get blue => ThemeData(
    scaffoldBackgroundColor: Colors.blue.shade100,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF333333)),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF333333),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Colors.blue

    // backgroundColor: Colors.blue,
    );

ThemeData get purple => ThemeData(
    scaffoldBackgroundColor: Colors.deepPurple.shade100,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF333333)),
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(color: Color(0xFF333333)),
      displayMedium: TextStyle(color: Color(0xFF333333)),
      displaySmall: TextStyle(color: Color(0xFF333333)),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFFFFFFF),
      opacity: 1.0,
    ),
    cardColor: const Color(0xFFFFFFFF),
    colorSchemeSeed: Colors.purple

    // backgroundColor: Colors.deepPurple,
    );

enum Themes { dark, grey, yellow, red, orange, blue, green, purple }

final Map<Themes, ThemeData> themeDataMap = {
  Themes.dark: darkTheme,
  Themes.yellow: yellow,
  Themes.red: red,
  Themes.green: green,
  Themes.blue: blue,
  Themes.purple: purple,
};

ThemeData getThemeData(Themes theme) {
  return themeDataMap[theme] ?? normalTheme; // Fallback to normalTheme
}

class ThemesUtils {
  static Themes fromMaterialColor(MaterialColor color) {
    if (color == Colors.yellow) return Themes.yellow;
    if (color == Colors.red) return Themes.red;
    if (color == Colors.green) return Themes.green;
    if (color == Colors.blue) return Themes.blue;
    if (color == Colors.deepPurple) return Themes.purple;
    return Themes.yellow; // Default theme
  }
}
