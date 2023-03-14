import 'package:flutter/material.dart';
import 'package:pal_mail/provider/pass_data.dart';
import 'package:pal_mail/screens/home_screen.dart';
import 'package:pal_mail/screens/login_and_signup_screen.dart';
import 'package:pal_mail/screens/new_inbox_screen.dart';
import 'package:pal_mail/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PassAllData>(
      create: (_) => PassAllData(),
      child: MaterialApp(
        initialRoute: SplashPage.id,
        routes: {
          SplashPage.id: (context) => const SplashPage(),
          LoginAndSignupPage.id: (context) => const LoginAndSignupPage(),
          HomePage.id: (context) => const HomePage(),
          NewInboxPage.id: (context) => const NewInboxPage(),
          // DetailsPage.id: (context) => const DetailsPage(),
          // AllSendersPage.id: (context) => const AllSendersPage(),
          // AllCategoryPage.id: (context) => const AllCategoryPage(),
        },
      ),
    );
  }
}
