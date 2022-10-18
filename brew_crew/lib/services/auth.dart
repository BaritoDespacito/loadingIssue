import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:brew_crew/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  myUser? _userFromFirebaseUser(User user) {
    return user != null ? myUser(uid: user.uid) : null;
  }

  Stream<myUser?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserData('0', email, 100);

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}