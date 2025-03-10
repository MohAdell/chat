import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Profile/model/users_info.dart';
import '../../Sign In/model/login_model.dart';
import '../../register/model/register_model.dart';
import 'firebase_data.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> login(LoginRequestBody loginRequest) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginRequest.email,
        password: loginRequest.password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email.';
        case 'wrong-password':
          throw 'Wrong password provided for that user.';
        default:
          throw 'Login failed. Please try again.';
      }
    } catch (e) {
      print('Login error: $e');
      throw 'An unknown error occurred during login.';
    }
  }

  Future resetPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset  error: $e');
    }
  }

  Future<User?> register(RegisterRequestBody requestBody) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: requestBody.email,
        password: requestBody.password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserProfile userProfile = UserProfile(
            id: user.uid,
            name: requestBody.name,
            email: requestBody.email,
            about: "is new user ",
            phoneNumber: requestBody.phoneNumber,
            createdAt: DateTime.now().toIso8601String(),
            lastActivated: DateTime.now().toIso8601String(),
            pushToken: "",
            online: true);
        await FireBaseDataAll().creatUser(userProfile);
      }

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("User canceled Google sign-in");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      print("Google sign-in successful: ${userCredential.user?.email}");

      return userCredential.user;
    } catch (e) {
      print('Google login error: $e');
      return null;
    }
  }

  Future<User?> registerWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        User? user = userCredential.user;
        if (user != null) {
          await FireBaseDataAll().creatUser(UserProfile(
            id: user.uid,
            name: user.displayName ?? "New User",
            email: user.email ?? "",
            phoneNumber: "000000000000",
            createdAt: DateTime.now().toIso8601String(),
            about: "I'm a new user",
            online: true,
            lastActivated: DateTime.now().toIso8601String(),
            pushToken: 'example-push-token',
          ));
        }
      }
      return userCredential.user;
    } catch (e) {
      print('Google registration error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }
}
