import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user signed in');
    }

    await user.updatePassword(newPassword);
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  User? get currentUser {
    return _auth.currentUser;
  }
}
