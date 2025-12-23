import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
    if (googleUser == null) {
      throw Exception('Sign in aborted');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut().catchError((_) {});
    await _auth.signOut();
  }

  Future<void> reauthWithPassword(String email, String password) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser?.reauthenticateWithCredential(cred);
  }

  Future<void> reauthWithGoogle() async {
    final googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
    if (googleUser == null) throw Exception('Reauth aborted');
    final googleAuth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    await _auth.currentUser?.reauthenticateWithCredential(cred);
  }

  Future<void> deleteAuthUser() async {
    await _auth.currentUser?.delete();
  }
}