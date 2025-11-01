class UserEntity {
  final String userId;
  final String accessToken;
  final String refreshToken;

  UserEntity({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });
}
