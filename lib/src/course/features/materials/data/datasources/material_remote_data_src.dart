import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/utils/datasource_utils.dart';
import 'package:tdd_education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';

abstract class MaterialRemoteDataSrc {
  Future<List<ResourceModel>> getMaterials(String courseId);

  Future<void> addMaterial(Resource material);
}

class MaterialRemoteDataSrcImpl implements MaterialRemoteDataSrc {
  const MaterialRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> addMaterial(Resource material) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final materialRef = _firestore
          .collection('courses')
          .doc(material.courseId)
          .collection('materials')
          .doc();
      var materialModel =
          (material as ResourceModel).copyWith(id: materialRef.id);
      if (materialModel.isFile) {
        final materialFileRef = _storage.ref().child(
              'courses/${materialModel.courseId}/materials/${materialModel.id}/material',
            );
        await materialFileRef
            .putFile(File(materialModel.fileURL))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          materialModel = materialModel.copyWith(fileURL: url);
        });
      }
      await materialRef.set(materialModel.toMap());

      await _firestore.collection('courses').doc(material.courseId).update({
        'numberOfMaterials': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<ResourceModel>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.authorizedUser(_auth);
      final materialsRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('materials');
      final materials = await materialsRef.get();
      return materials.docs
          .map((e) => ResourceModel.fromMap(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
