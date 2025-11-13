class UserModel {
  final String uid;
  final String email;
  final String role; // 'admin' أو 'user'
  final String? name; // اختياري

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
  });

  // لتحويل كائن المستخدم إلى خريطة (Map) لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'role': role, 'name': name};
  }

  // لتحويل بيانات Firestore إلى كائن UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      name: map['name'],
    );
  }
}
