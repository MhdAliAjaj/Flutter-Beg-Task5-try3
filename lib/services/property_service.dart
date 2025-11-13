import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_model.dart';

class PropertyService {
  final CollectionReference _properties = FirebaseFirestore.instance.collection(
    'properties',
  );

  // CREATE
  Future<void> addProperty(PropertyModel property) async {
    await _properties.add(property.toMap());
  }

  // READ
  Future<List<PropertyModel>> getAllProperties() async {
    final snapshot = await _properties.get();
    return snapshot.docs
        .map(
          (doc) =>
              PropertyModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  // UPDATE
  Future<void> updateProperty(PropertyModel property) async {
    await _properties.doc(property.id).update(property.toMap());
  }

  // DELETE
  Future<void> deleteProperty(String id) async {
    await _properties.doc(id).delete();
  }
}
