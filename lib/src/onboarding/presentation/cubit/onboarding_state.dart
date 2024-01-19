part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class CachingFirstTimer extends OnboardingState {
  const CachingFirstTimer();
}

class CheckingIfUserIsFirstTimer extends OnboardingState {
  const CheckingIfUserIsFirstTimer();
}

class UserCached extends OnboardingState {
  const UserCached();
}

class OnboardingStatus extends OnboardingState {
  const OnboardingStatus({required this.isFirstTimer});

  final bool isFirstTimer;

  @override
  List<Object> get props => [isFirstTimer];
}

class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
