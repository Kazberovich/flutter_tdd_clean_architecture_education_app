import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/course/features/videos/data/datasourses/video_remote_datasource.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/data/repositories/video_repository_implementation.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';

class MockVideoRemoteDataSource extends Mock implements VideoRemoteDataSource {}

void main() {
  late VideoRemoteDataSource remoteDataSource;
  late VideoRepositoryImplementation repositoryImplementation;

  final tVideo = VideoModel.empty();
  const tException = ServerException(message: 'message', statusCode: '505');

  setUp(() {
    remoteDataSource = MockVideoRemoteDataSource();
    repositoryImplementation = VideoRepositoryImplementation(remoteDataSource);
    registerFallbackValue(tVideo);
  });

  group('addVideo', () {
    test(
      'should complete successfully when call '
      'to remote data source is successful',
      () async {
        when(() => remoteDataSource.addVideo(any())).thenAnswer(
          (invocation) async => Future.value(),
        );

        final result = await repositoryImplementation.addVideo(tVideo);

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => remoteDataSource.addVideo(tVideo)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call '
      'to remote data source is unsuccessful',
      () async {
        when(() => remoteDataSource.addVideo(tVideo)).thenThrow(tException);

        final result = await repositoryImplementation.addVideo(tVideo);

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(tException),
            ),
          ),
        );

        verify(() => remoteDataSource.addVideo(tVideo)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getVideos', () {
    test(
      'should return List<Video> successfully when call '
      'to remote data source is successful',
      () async {
        when(() => remoteDataSource.getVideos(any())).thenAnswer(
          (_) async => [tVideo],
        );

        final result = await repositoryImplementation.getVideos('courseId');

        expect(result, isA<Right<dynamic, List<Video>>>());
        verify(() => remoteDataSource.getVideos('courseId')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call '
      'to remote data source is unsuccessful',
      () async {
        when(() => remoteDataSource.getVideos('courseId'))
            .thenThrow(tException);

        final result = await repositoryImplementation.getVideos('courseId');

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(tException),
            ),
          ),
        );

        verify(() => remoteDataSource.getVideos('courseId')).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
