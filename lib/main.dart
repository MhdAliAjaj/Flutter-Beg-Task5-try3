import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './core/firebase/firebase_options.dart';
import './routes/app_routes.dart'; // ✅ هنا التصحيح
import './auth/login_screen.dart';
import './auth/register_screen.dart';
import './home/user_dashboard.dart';
import './admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes, // ✅ الأفضل تستخدم الماب الجاهزة
    );
  }
}
