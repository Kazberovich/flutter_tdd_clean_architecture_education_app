import 'package:equatable/equatable.dart';

class UserChoice extends Equatable {
  const UserChoice({
    required this.userChoice,
    required this.questionId,
    required this.correctChoice,
  });

  const UserChoice.empty()
      : this(
          userChoice: 'empty.userChoice',
          questionId: 'empty.questionId',
          correctChoice: 'empty.correctChoice',
        );

  final String userChoice;
  final String questionId;
  final String correctChoice;

  bool get isCorrect => userChoice == correctChoice;

  @override
  List<Object?> get props => [userChoice, questionId, correctChoice];
}
