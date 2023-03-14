import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pal_mail/constants.dart';
import 'package:pal_mail/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_and_signup_screen.dart';

class SplashPage extends StatefulWidget {
  static const String id = "SplashPage";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Duration duration = const Duration(seconds: 2);
  bool isUserLogin = false;

  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    isUserLogin = token == null ? false : true;
  }

  @override
  void initState() {
    super.initState();
    getToken();

    controller = AnimationController(vsync: this, duration: duration);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    Timer(
      const Duration(seconds: 3),
      () => isUserLogin ? Navigator.pushReplacementNamed(context, HomePage.id)
      : Navigator.pushReplacementNamed(context, LoginAndSignupPage.id),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: controller.value * 150,
                    width: controller.value * 150,
                    child: Image.asset('images/icon.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Pal Mail",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kMainColorDark,
                    fontSize: controller.value * 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
