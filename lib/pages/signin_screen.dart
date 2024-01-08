import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallyapp/config/config.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;

      await _db.collection("users").doc(user.uid).set({
        "displayName": user.displayName,
        "email": user.email,
        "uid": user.uid,
        "photoUrl": user.photoURL,
        "lastSignIn": FieldValue.serverTimestamp(), // Use server timestamp instead of DateTime.now()
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error signing in: $e");
      // Handle error as needed (e.g., show an error dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage("assets/bg.jpg"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 200,
              ),
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage("assets/logo_circle.png"),
                width: 200,
                height: 200,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000000),
                    Color(0x00000000),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: InkWell(
                  onTap: _signIn,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Google Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
