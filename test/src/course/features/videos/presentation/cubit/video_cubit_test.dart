import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:tdd_education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:tdd_education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';

class MockAddVideo extends Mock implements AddVideo {}

class MockGetVideos extends Mock implements GetVideos {}

void main() {
  late AddVideo addVideo;
  late GetVideos getVideos;
  late VideoCubit videoCubit;

  final tVideo = VideoModel.empty();

  setUp(() {
    addVideo = MockAddVideo();
    getVideos = MockGetVideos();
    videoCubit = VideoCubit(
      addVideo: addVideo,
      getVideos: getVideos,
    );
    registerFallbackValue(tVideo);
  });

  tearDown(() {
    videoCubit.close();
  });

  test(
    'initial state should be [VideoInitial]',
        () async {
      expect(videoCubit.state, const VideoInitial());
    },
  );

  group('addVideo', () {
    blocTest<VideoCubit, VideoState>(
      'emits [AddingVideo, VideoAdded] when addVideo is called',
      build: () {
        when(() => addVideo(any())).thenAnswer((_) async => const Right(null));
        return videoCubit;
      },
      act: (cubit) => cubit.addVideo(tVideo),
      expect: () => const <VideoState>[
        AddingVideo(),
        VideoAdded(),
      ],
      verify: (_) {
        verify(() => addVideo(tVideo)).called(1);
        verifyNoMoreInteractions(addVideo);
      },
    );

    blocTest<VideoCubit, VideoState>(
      'emits [AddingVideo, VideoError] when addVideo is called and fails',
      build: () {
        when(() => addVideo(any())).thenAnswer(
              (_) async => Left(
            ServerFailure(message: 'Server Failure', statusCode: 500),
          ),
        );
        return videoCubit;
      },
      act: (cubit) => cubit.addVideo(tVideo),
      expect: () => const <VideoState>[
        AddingVideo(),
        VideoError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => addVideo(tVideo)).called(1);
        verifyNoMoreInteractions(addVideo);
      },
    );
  });

  group('getVideos', () {
    blocTest<VideoCubit, VideoState>(
      'emits [LoadingVideos, VideosLoaded] when getVideos is called',
      build: () {
        when(() => getVideos(any())).thenAnswer((_) async => const Right([]));
        return videoCubit;
      },
      act: (cubit) => cubit.getVideos('testId'),
      expect: () => const <VideoState>[
        LoadingVideos(),
        VideosLoaded([]),
      ],
      verify: (_) {
        verify(() => getVideos('testId')).called(1);
        verifyNoMoreInteractions(getVideos);
      },
    );

    blocTest<VideoCubit, VideoState>(
      'emits [LoadingVideos, VideoError] when getVideos is called and fails',
      build: () {
        when(() => getVideos(any())).thenAnswer(
              (_) async => Left(
            ServerFailure(message: 'Server Failure', statusCode: 500),
          ),
        );
        return videoCubit;
      },
      act: (cubit) => cubit.getVideos('testId'),
      expect: () => const <VideoState>[
        LoadingVideos(),
        VideoError('500 Error : Server Failure'),
      ],
      verify: (_) {
        verify(() => getVideos('testId')).called(1);
        verifyNoMoreInteractions(getVideos);
      },
    );
  });
}
