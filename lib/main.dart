import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/palette.dart';
import 'package:flutter_app/domain/quiz/src/models/models.dart';
import 'package:flutter_app/providers/quiz_provider.dart';
import 'package:flutter_app/providers/themestock_provider.dart';
import 'package:flutter_app/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'domain/themestock/src/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        FutureProvider<List<Quiz>>(
          create: (context) => QuizProvider().loadQuizData(),
        ),
        FutureProvider<List<ThemeStock>>(
          create: (context) => ThemestockProvider().loadThemeData(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Palette.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
