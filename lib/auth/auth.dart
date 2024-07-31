import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; //instance of firebase auth

  //sign in anon
  Future signInAnon() async {
    //Signing in anonymously could end up in error, so we use try-catch block
    try {
      UserCredential result = await _auth.signInAnonymously();
      //AuthResult deprecated, now UserCredential
      User user = result.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //send email verification
  Future<void> sendEmailVerification() async {
    final _user = FirebaseAuth.instance.currentUser;
    if (_user != null && !_user.emailVerified) {
      await _user.sendEmailVerification();
      // Optionally, display a message informing the user to check their email
    }
  }

  //send email for password reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent');
  }

  //delete user
  Future<void> deleteUser() async {
    final _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      await _user.delete();
    print('User deleted');
    }
  }
}
