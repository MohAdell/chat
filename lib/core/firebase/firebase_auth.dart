import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Profile/model/users_info.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> createUser() async {
    User? user = auth.currentUser;

    if (user == null) {
      print("No user is currently signed in.");
      return;
    }

    UserProfile userProfile = UserProfile(
      id: user.uid,
      name: user.displayName ?? "",
      email: user.email ?? "",
      about: "Hello, I'm new user",
      phoneNumber: user.phoneNumber ?? "",
      createdAt: DateTime.now().toString(),
      lastActivated: DateTime.now().toString(),
      pushToken: "",
      online: false,
    );

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toJson());

      print("User data saved successfully!");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }
}
