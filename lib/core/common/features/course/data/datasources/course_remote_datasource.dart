import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tdd_education_app/core/common/features/course/data/models/course_model.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';

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
  Future<void> addCourse(Course course) {
    // TODO: implement getCourses
    throw UnimplementedError();
  }

  @override
  Future<List<CourseModel>> getCourses() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}
