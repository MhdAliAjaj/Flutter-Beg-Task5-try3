import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل مستخدم جديد
  Future<User?> signUp(String email, String password, String role) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // إنشاء موديل المستخدم
      final userModel = UserModel(
        uid: cred.user!.uid,
        email: email,
        role: role,
      );

      // حفظ المستخدم في Firestore
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());

      return cred.user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  // تسجيل الدخول
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
