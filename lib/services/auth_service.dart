import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_calling/screens/verification_screen.dart';
import 'package:video_calling/services/shared_preferences_service.dart';

final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        credential.providerId;
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationScreen(),
          ),
        );
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<int> getNextUserId() async {
    final snapshot = await databaseReference.child('lastUserId').get();
    if (snapshot.exists) {
      int lastUserId = snapshot.value as int;
      int nextUserId = lastUserId + 1;
      await databaseReference.child('lastUserId').set(nextUserId);
      return nextUserId;
    } else {
      // Initialize the lastUserId if it doesn't exist
      await databaseReference.child('lastUserId').set(1);
      return 1;
    }
  }

  Future<bool> signInWithOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);

      int userId = await getNextUserId();
      SharedPref.setString('uid', userId.toString());

      // Use the userId for your operations, e.g., creating a new user record
      print('The new user ID is $userId');

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
