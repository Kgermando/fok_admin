// create anon account decoder
class AuthTokenDecoder {
  final int? id;
  late String accessToken;
  late String refreshToken;

  AuthTokenDecoder({
      required this.id,
      required this.accessToken, required this.refreshToken});


  factory AuthTokenDecoder.fromSQL(List<dynamic> row) {
    return AuthTokenDecoder(id: row[0], accessToken: row[1], refreshToken: row[2]);
  }

  factory AuthTokenDecoder.fromJson(Map<String, dynamic> json) {
    return AuthTokenDecoder(
      id : json['id'],
      accessToken: json['accessToken'],
      refreshToken : json['refreshToken']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accessToken': accessToken,
      'refreshToken': refreshToken 
    };
  }
}
