import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  Future<User?> signUpWithEmail(String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String? idToken = await user.getIdToken();
        print(idToken);
        await _sendDataToBackend(idToken, email, name, phone, "signup").then((_) async=> await user.sendEmailVerification());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Email already in use");
        return null;
      } else {
        print("Error: ${e.message}");
        return null;
      }
    }
    catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String? idToken = await user.getIdToken();
        print(idToken);
        // await _sendDataToBackend(idToken, email, "", "", "signin");
      }
      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String? idToken = await user.getIdToken();
        await _sendDataToBackend(idToken, user.email!, user.displayName, user.phoneNumber, "google");
      }
      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> _sendDataToBackend(String? idToken, String email, String? name, String? phone, String method) async {
    final response = await http.post(
      Uri.parse("http://192.168.2.41:5000/authenticate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "idToken": idToken,
        "email": email,
        "name": name,
        "phone": phone,
        "method": method
      }),
    );

    if (response.statusCode == 200) {
      print("User authenticated and data stored successfully.");
    } else {
      print("Backend authentication failed: ${response.body}");
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    print(user);
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
