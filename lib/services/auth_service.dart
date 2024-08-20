import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/home_screen.dart';
import 'package:beauty_hack/screens/signin_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // signInWithGoogle() async {

  //   try {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn(
  //       scopes: <String>["email"]).signIn();
  //   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   print("credss********************************* : $credential");
  //   UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
  //   print("credss***************************55***** : $cred");
  
  // } on FirebaseAuthException catch (e){
  //   throw e;
  // }
  
  // }

  // signOut(){
  //   FirebaseAuth.instance.signOut();
  //   GoogleSignIn().signOut();
  // }
}