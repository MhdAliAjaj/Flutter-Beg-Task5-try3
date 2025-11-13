import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedRole = 'user'; // افتراضيًا المستخدم العادي
  bool _loading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userModel = UserModel(
        uid: cred.user!.uid,
        email: _emailController.text.trim(),
        role: _selectedRole,
        name: _nameController.text.trim(),
      );

      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم التسجيل بنجاح ✅')));
      }

      Navigator.pop(context); // يرجع لصفحة تسجيل الدخول
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في التسجيل: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(controller: _nameController, hintText: 'الاسم'),
              CustomTextField(
                controller: _emailController,
                hintText: 'الإيميل',
              ),
              CustomTextField(
                controller: _passwordController,
                hintText: 'كلمة المرور',
                obscure: true,
              ),

              const SizedBox(height: 10),

              // اختيار الدور
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الدور',
                ),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('مستخدم')),
                  DropdownMenuItem(value: 'admin', child: Text('مدير')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),

              const SizedBox(height: 20),

              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(text: 'تسجيل', onPressed: _register),
            ],
          ),
        ),
      ),
    );
  }
}
