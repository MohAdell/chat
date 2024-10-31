import 'package:chatt/register/logic/register_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Contacts/logic/rooms_cubit.dart';
import 'Sign In/logic/login_cubit.dart';
import 'Profile/logic/users_cubit.dart';
import 'chat/logic/chat_cubit.dart';
import 'core/firebase/firebase_data.dart';
import 'core/firebase/firebase_sevice.dart';
import 'core/notifcations.dart';
import 'core/utils/routes.dart';
import 'firebase_options.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Nofifcation().requestNotificationPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
            create: (context) => UsersCubit(FireBaseDataAll())),
        BlocProvider<RoomsCubit>(
            create: (context) => RoomsCubit(FireBaseDataAll())),
        BlocProvider<RegisterCubit>(
            create: (context) => RegisterCubit(FirebaseService())),
        BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(FirebaseService())),
        BlocProvider<MessageCubit>(
            create: (context) => MessageCubit(FireBaseDataAll())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Routes.splashScreen,
        // home: SplashScreen(),
      ),
    );
  }
}
