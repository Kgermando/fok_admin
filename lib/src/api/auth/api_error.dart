class ApiError {
  final String code;
  final dynamic message;

  ApiError({
    required this.code,
    this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> jsonMap) {
    return ApiError(
      code: jsonMap["code"],
      message: jsonMap["error"],
    );
  }
}