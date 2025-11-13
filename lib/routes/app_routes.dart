import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../home/user_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../admin/manage_users_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String userDashboard = '/userDashboard';
  static const String adminDashboard = '/adminDashboard';
  static const String manageUsers = '/manageUsers';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    userDashboard: (context) => const UserDashboard(),
    adminDashboard: (context) => const AdminDashboard(),
    manageUsers: (context) => const ManageUsersScreen(),
  };
}
