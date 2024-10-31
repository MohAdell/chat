import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Future<void> _navigateBasedOnAuth() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //
  //   bool hasVisitedOnboarding = await SharedPrefsHelper.getVisitedOnboarding();
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null && hasVisitedOnboarding) {
  //     Navigator.pushReplacementNamed(context, Routes.homeScreen);
  //   } else if (user == null && hasVisitedOnboarding) {
  //     Navigator.pushReplacementNamed(context, Routes.loginScreen);
  //   } else {
  //     Navigator.pushReplacementNamed(context, Routes.onBoardingScreen);
  //   }
  // }
  void isLogin()async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isLogin = sp.getBool('isLogin') ?? false;

    if(isLogin){
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);
      });

    }else{
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, Routes.onBoardingScreen);
      });

    }
  }

  @override
  void initState() {
    super.initState();
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => SecondSplashScreen())));
    isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.asset(
        'assets/Splash (2).jpg',
      ),
    );
  }
}
