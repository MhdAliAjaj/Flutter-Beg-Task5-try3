import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/property_model.dart';

class PropertyService {
  final CollectionReference _properties = FirebaseFirestore.instance.collection(
    'properties',
  );

  /// -------------------------
  /// ADD NEW PROPERTY
  /// -------------------------
  Future<void> addProperty(PropertyModel property) async {
    await _properties.add(property.toMap());
  }

  /// -------------------------
  /// GET ALL PROPERTIES
  /// -------------------------
  Future<List<PropertyModel>> getAllProperties() async {
    final snapshot = await _properties.get();

    return snapshot.docs
        .map(
          (doc) =>
              PropertyModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  /// -------------------------
  /// UPDATE PROPERTY
  /// -------------------------
  Future<void> updateProperty(PropertyModel property) async {
    await _properties.doc(property.id).update(property.toMap());
  }

  /// -------------------------
  /// DELETE PROPERTY
  /// -------------------------
  Future<void> deleteProperty(String id) async {
    await _properties.doc(id).delete();
  }

  /// --------------------------------------------------
  /// UPLOAD IMAGE (WEB + MOBILE) — uses bytes for all platforms
  /// --------------------------------------------------
  Future<String> uploadImage({required Uint8List bytes}) async {
    try {
      final storage = FirebaseStorage.instance;

      final String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch}.jpg";

      final Reference ref = storage
          .ref()
          .child("property_images")
          .child(fileName);

      final UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: "image/jpeg"),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception("Upload failed: ${e.code} ${e.message}");
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }

  Future<String> uploadImageFromAssets(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      return await uploadImage(bytes: bytes);
    } catch (e) {
      throw Exception("Asset load failed: $e");
    }
  }
}
