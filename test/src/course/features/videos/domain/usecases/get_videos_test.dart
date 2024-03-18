import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/repositories/video_repository.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:test/test.dart';

import 'vide_repository.mock.dart';

void main() {
  late VideoRepository repository;
  late GetVideos usecase;

  setUp(() {
    repository = MockVideoRepository();
    usecase = GetVideos(repository);
  });

  final tVideo = Video.empty();

  test('should call [VideoRepository.getVideos]', () async {
    when(() => repository.getVideos(any()))
        .thenAnswer((_) async => Right([tVideo]));

    final result = await usecase('testId');

    expect(result, isA<Right<dynamic, List<Video>>>());
    verify(() => repository.getVideos('testId')).called(1);
    verifyNoMoreInteractions(repository);
  });
}
