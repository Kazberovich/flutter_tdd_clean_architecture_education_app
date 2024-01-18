abstract class OnboardingLocalDataSource {
  const OnboardingLocalDataSource();

  Future<void> cacheFirstTimer();

  Future<bool> checkIfUserIsFirstTimer();
}
