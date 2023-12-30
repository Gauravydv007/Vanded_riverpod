import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpodapp/Homepage.dart';
import 'package:riverpodapp/Homepage2.dart';
import 'package:riverpodapp/Homepage4.dart';

void main() {
  runApp(
    const ProviderScope(
      child : App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key ?key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    home: HomePage4(),

    );
  }
}
