import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password');
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use by another account');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid');
      } else {
        throw Exception('Something went wrong: ${e.message}');
      }
    } catch (e) {
      throw Exception('Something went wrong: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error during logout: ${e.toString()}');
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
}
}