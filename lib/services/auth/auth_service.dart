import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //save user info if already doesnot exist
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "uid": userCredential.user!.uid,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      //create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // save userto firestore
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "uid": userCredential.user!.uid,
        "lastOnline": DateTime.now(),
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
}
