
class Token {
  final int? id;
  final String accessToken;
  final String refreshToken;

  Token({
    this.id,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> jsonMap) {
    return Token(
      id: jsonMap["id"],
      accessToken: jsonMap["auth_token"],
      refreshToken: jsonMap["refresh_token"],
    );
  }
}