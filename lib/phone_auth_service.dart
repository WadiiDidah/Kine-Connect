import 'package:firebase_auth/firebase_auth.dart';

String _verificationId = '';

Future<String> verifyCode(String smsCode) async {
  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    return 'true';
  } catch (_) {
    return 'false';
  }
}

Future<void> sendVerificationCode(String phoneNumber) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: const Duration(seconds: 30),
    verificationCompleted: (credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (_) {},
    codeSent: (verificationId, resendToken) {
      _verificationId = verificationId;
    },
    codeAutoRetrievalTimeout: (verificationId) {
      _verificationId = verificationId;
    },
  );
}
