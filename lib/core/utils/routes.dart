import 'package:flutter/material.dart';

import '../../Contacts/UI/contacts_ui.dart';
import '../../Profile/model/users_info.dart';
import '../../Sign In/UI/signin_ui.dart';
import '../../UI/home_ui.dart';
import '../../UI/second_splash_screen.dart';
import '../../UI/splash_screen.dart';
import '../../chat/UI/chat_ui.dart';
import '../../register/ui/signup_ui.dart';

class Routes {
  static const String splashScreen = '/splashscreen';
  static const String onBoardingScreen = '/SecondSplashScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String homeScreen = '/homeScreen';
  static const String forgetpass = '/forgetpass';
  static const String selectUserScreen = '/SelectUserScreen';
  static const String chatScreen = '/chatscreen';
}

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const SecondSplashScreen());
      // case Routes.forgetpass:
      //   return MaterialPageRoute(
      //     builder: (_) => const ForgetPasswordScreen(),
      //   );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const SigninUi(),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignupUi(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeUi(),
        );
      case Routes.selectUserScreen:
        return MaterialPageRoute(
          builder: (_) => const ContactsUi(),
        );
      case Routes.chatScreen:
        final userProfile = settings.arguments as UserProfile;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(userProfile: userProfile),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
