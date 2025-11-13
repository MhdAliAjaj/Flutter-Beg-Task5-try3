import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final _emailController = TextEditingController();
  final _roleController = TextEditingController(text: 'user');
  bool isLoading = false;

  final _firestore = FirebaseFirestore.instance;

  Future<void> _addUser() async {
    setState(() => isLoading = true);

    try {
      await _firestore.collection('users').add({
        'email': _emailController.text.trim(),
        'role': _roleController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المستخدم بنجاح ✅')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة مستخدم جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'إيميل المستخدم',
            ),
            DropdownButtonFormField<String>(
              value: _roleController.text,
              decoration: const InputDecoration(
                labelText: 'الدور',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('مستخدم عادي')),
                DropdownMenuItem(value: 'admin', child: Text('مسؤول')),
              ],
              onChanged: (value) {
                _roleController.text = value!;
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: 'إضافة المستخدم', onPressed: _addUser),
          ],
        ),
      ),
    );
  }
}
