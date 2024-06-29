import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

// Auth Methods
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
