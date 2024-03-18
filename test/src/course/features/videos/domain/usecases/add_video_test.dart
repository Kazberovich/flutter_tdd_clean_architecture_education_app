import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/repositories/video_repository.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:test/test.dart';

import 'vide_repository.mock.dart';

void main() {
  late VideoRepository repository;
  late AddVideo usecase;

  final tVideo = Video.empty();

  setUp(() {
    repository = MockVideoRepository();
    usecase = AddVideo(repository);
    registerFallbackValue(tVideo);
  });

  test('should call [Video.addVideo]', () async {
    when(() => repository.addVideo(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tVideo);

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repository.addVideo(tVideo)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
