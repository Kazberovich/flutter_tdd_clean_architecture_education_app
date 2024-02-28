import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tdd_education_app/core/common/features/course/data/models/course_model.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/src/chat/data/models/group_model.dart';

abstract class CourseRemoteDataSource {
  const CourseRemoteDataSource();

  Future<List<CourseModel>> getCourses();

  Future<void> addCourse(Course course);
}

class CourseRemoteDataSourceImplementation implements CourseRemoteDataSource {
  const CourseRemoteDataSourceImplementation({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firebaseFirestore = firestore,
        _firebaseStorage = storage,
        _firebaseAuth = auth;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> addCourse(Course course) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final courseRef = _firebaseFirestore.collection('courses').doc();
      final groupRef = _firebaseFirestore.collection('groups').doc();

      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        groupId: groupRef.id,
      );

      if (courseModel.imageIsFile) {
        final imageRef = _firebaseStorage.ref().child(
              'courses/${courseModel.id}/profile_image/${courseModel.title}-pfp',
            );

        await imageRef.putFile(File(courseModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          courseModel = courseModel.copyWith(image: url);
        });
      }

      await courseRef.set(courseModel.toMap());

      final group = GroupModel(
        id: groupRef.id,
        name: course.title,
        members: const [],
        courseId: courseRef.id,
        groupImageUrl: courseModel.image,
      );

      return groupRef.set(group.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<CourseModel>> getCourses() {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }

      return _firebaseFirestore.collection('courses').get().then(
            (value) => value.docs
                .map((document) => CourseModel.fromMap(document.data()))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
