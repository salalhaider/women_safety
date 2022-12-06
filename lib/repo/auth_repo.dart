// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/repo/user_repo.dart';
import 'package:women_safety_app/utils/utils.dart';

class AuthRepo {
  UserRepo userRepo = UserRepo();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _fcm = FirebaseMessaging.instance;

  signIn(String email, String password, BuildContext context) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showSnackBar(context, 'Wrong password provided for that user.');
      } else {
        showSnackBar(context, e.message!);
      }
      showSnackBar(context, e.message!);
    }

    if (userCredential != null) {
      return true;
    }
  }

  // signUp(String email, String password, dynamic user) async {
  //   print('-------- sign up function ---------');
  //   UserCredential? userCredential;
  //   try {
  //     print('-------- try ---------');
  //     userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: email,
  //             password: password)
  //         .catchError((e, s) {
  //       print(e);
  //       print(s);
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     print('-------- on ---------');
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print('-------- catch ---------');
  //     print(e);
  //   }

  //   if (userCredential != null) {
  //     print('-------- result not null ---------');
  //     user.id = userCredential.user!.uid;
  //     userRepo.createNewUser(userCredential.user!.uid, user);
  //   } else {
  //     print('-------- result is null ---------');
  //     print('user is nulllll');
  //   }
  // }

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required dynamic newUser,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
      newUser.id = userCredential.user!.uid;
      await userRepo.createNewUser(userCredential.user!.uid, newUser);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Password reset link sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> saveDeviceToken(String id) async {
    // Get the current user
    String? uid = auth.currentUser?.uid;

    if (uid != null) {
      // Get the token for this device
      String? fcmToken = await _fcm.getToken();

      // Save it to Firestore
      if (fcmToken != null) {
        // DocumentReference tokens =
        await _firestore.collection('users').doc(id).set({
          'notifToken': fcmToken,
        });
        return fcmToken;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
