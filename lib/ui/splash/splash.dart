import 'dart:async';

import 'package:ali_poster/data/prefs/shared_preferences.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:ali_poster/ui/auth/login.dart';
import 'package:ali_poster/ui/main/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      if (await isLoggedIn()) {
        Navigator.pushReplacementNamed(context, HomePage.route);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset('assets/images/background.jpg').image,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const Text(
              'ALIPOSTER АВТОМАТИЗАЦИЯ ТОРГОВЛИ БИЗНЕСА РЕСТОРАНОВ И КАФЕ',
              textAlign: TextAlign.center,
              style: AppTextStyle.splashText,
            ),
          ],
        ),
      ),
    );
  }
}
