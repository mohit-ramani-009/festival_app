import 'package:festival_app/screen/detail_screen.dart';
import 'package:festival_app/screen/home_screen.dart';
import 'package:festival_app/screen/splace_Screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_page',
      routes: {
        '/': (context) => const Home_Screen(),
        'splash_page': (context) => const SplashScreen(),
        'DetailPage': (context) => const DetailPage(),
      },
    ),
  );
}
