import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/keys/navigator_key.dart';
import 'package:ewallet/keys/snackbar_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Future<void> signUp(
      {required String emailAddress,
      required String password,
      required String userName,
      required String phoneNumber,
      required String fullName}) async {
    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);

      await db.collection('users').doc(userCredential.user!.uid).set({
        "fullName": fullName,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "balance": 0,
        "uid": userCredential.user!.uid
      });

      navigatorKey.currentState?.pop();
      const errSnackBar = SnackBar(
          content: Text("Account Successfully Registered"),
          duration: Duration(seconds: 5));
      snackbarKey.currentState?.showSnackBar(errSnackBar);
    } on FirebaseAuthException catch (error) {
      String errMessage = "";

      if (error.code == 'weak-password') {
        errMessage = "Please provide a stronger password";
      } else if (error.code == 'email-already-in-use') {
        errMessage = "Email has already been registered";
      } else {
        errMessage = error.toString();
      }

      final errSnackBar = SnackBar(
          content: Text(errMessage), duration: const Duration(seconds: 5));
      snackbarKey.currentState?.showSnackBar(errSnackBar);
    } catch (error) {
      String errMessage = error.toString();

      final errSnackBar = SnackBar(
          content: Text(errMessage), duration: const Duration(seconds: 5));
      snackbarKey.currentState?.showSnackBar(errSnackBar);
    }
  }

  Future<void> login(
      {required String emailAddress, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      navigatorKey.currentState?.popAndPushNamed('/loading');

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);

      _user = userCredential.user;
      fetchUserData();
      navigatorKey.currentState?.popAndPushNamed('/home');
    } on FirebaseAuthException catch (error) {
      String errMessage = "";

      if (error.code == 'user-not-found') {
        errMessage = "Email has not been registered";
      } else if (error.code == 'wrong-password') {
        errMessage = "Invalid password";
      } else {
        errMessage = error.toString();
      }

      navigatorKey.currentState?.popAndPushNamed('/');
      final errSnackBar = SnackBar(
          content: Text(errMessage), duration: const Duration(seconds: 5));
      snackbarKey.currentState?.showSnackBar(errSnackBar);
    } catch (error) {
      String errMessage = error.toString();
      navigatorKey.currentState?.popAndPushNamed('/');

      final errSnackBar = SnackBar(
          content: Text(errMessage), duration: const Duration(seconds: 5));
      snackbarKey.currentState?.showSnackBar(errSnackBar);
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    if (currentUser == null) {
      print("User is not signed in");
    } else {
      print("User is signed out");
      user = null;
      await auth.signOut();
    }
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      _userData = userSnapshot.data() as Map<String, dynamic>;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}