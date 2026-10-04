import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = cred.user!;
    await user.updateDisplayName(username.trim());

    // document id = uid عشان تربط الـ Auth بالـ Firestore
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'username': username.trim(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> logout() => _auth.signOut();


  static String errorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email Already in use';
      case 'invalid-email':
        return 'Invalid Email';
      case 'weak-password':
        return 'Weak Password';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid Email or Password';
      case 'too-many-requests':
        return 'Too many requests, please try again later';
      case 'network-request-failed':
        return 'Please check your internet connection';
      default:
        return 'error : ${e.message}';
    }
  }
}