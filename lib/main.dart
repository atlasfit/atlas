import 'package:atlas/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this line
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/services/auth.dart';

import 'dart:convert'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load theme
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  // Run the app
  runApp(MainApp(theme: theme));
}

class MainApp extends StatelessWidget {
  final ThemeData theme;

  const MainApp({super.key, required this.theme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AtlasUser?>.value(
      value: AuthService().atlasUser,
      initialData: null,
      child: MaterialApp(home: const Wrapper(), theme: theme),
    );
  }
}
