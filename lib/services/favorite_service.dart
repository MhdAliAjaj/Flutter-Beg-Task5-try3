import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final CollectionReference _favorites = FirebaseFirestore.instance.collection(
    'favorites',
  );

  // إضافة عقار للمفضلة
  Future<void> addToFavorites(String userId, String propertyId) async {
    await _favorites.add({
      'userId': userId,
      'propertyId': propertyId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // حذف عقار من المفضلة
  Future<void> removeFromFavorites(String userId, String propertyId) async {
    final snapshot = await _favorites
        .where('userId', isEqualTo: userId)
        .where('propertyId', isEqualTo: propertyId)
        .get();

    for (var doc in snapshot.docs) {
      await _favorites.doc(doc.id).delete();
    }
  }

  // جلب كل العقارات المفضلة لمستخدم
  Future<List<String>> getFavorites(String userId) async {
    final snapshot = await _favorites.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => doc['propertyId'] as String).toList();
  }
}
