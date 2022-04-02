class User {
  final bool success;
  final String authorization;

  User({
    required this.success,
    required this.authorization,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      success: json['success'],
      authorization:
          json['authToken'] == null ? "noAuthTokenVariable" : json['authToken'],
    );
  }
}
