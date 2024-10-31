import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../UI/home_ui.dart';
import '../../UI/second_splash_screen.dart';
import '../../core/firebase/firebase_sevice.dart';
import '../UI/signin_ui.dart';
import '../model/login_model.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseService _auth;
  final FirebaseAuth authhhh = FirebaseAuth.instance;
  LoginCubit(this._auth) : super(LoginInitial());

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future login(context) async {
    if (!formKey.currentState!.validate()) {
      emit(LoginFeliuer('Please fill in all fields correctly.'));
      return;
    }
    emit(LoginLoading());
    try {
      LoginRequestBody mymodel =
          LoginRequestBody(email: email.text, password: pass.text);

      User? user = await _auth.login(mymodel);

      if (user != null) {
        emit(LoginSuces(user));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeUi()),
        );
      } else {
        emit(LoginFeliuer("login is feluier"));
      }
    } catch (e) {
      emit(LoginFeliuer("$e  is error "));
    }
  }

  Future<void> loginWithGoogle(context) async {
    emit(LoginLoading()); // Emit loading state
    try {
      // Attempt to log in using Google Sign-In
      User? user = await _auth.loginWithGoogle();

      if (user != null) {
        // If login is successful, emit the success state
        emit(LoginSuces(user));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeUi()));
      } else {
        // Emit failure state if user cancels or login fails
        emit(LoginFeliuer("Google login was canceled or failed."));
      }
    } catch (e) {
      // Emit failure state if there is an error
      emit(LoginFeliuer("Google login error: $e"));
    }
  }

  Future logout(context) async {
    await authhhh.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SecondSplashScreen()),
            (route) => false));
  }

  @override
  Future<void> close() {
    email.dispose();
    pass.dispose();
    return super.close();
  }
}
