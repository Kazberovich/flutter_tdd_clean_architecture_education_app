import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePicture,
    this.bio,
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          points: 0,
          fullName: '',
          profilePicture: '',
          bio: '',
          groupIds: const [],
          enrolledCourseIds: const [],
          followers: const [],
          following: const [],
        );

  final String uid;
  final String email;
  final String? profilePicture;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  bool get isAdmin => email == 'vijijoc589@fahih.com';

  @override
  List<Object?> get props => [
        uid,
        email,
        bio,
        fullName,
        profilePicture,
        points,
        groupIds.length,
        enrolledCourseIds.length,
        followers.length,
        following.length,
      ];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: $bio,'
        ' points: $points, fullName: $fullName}';
  }
}
