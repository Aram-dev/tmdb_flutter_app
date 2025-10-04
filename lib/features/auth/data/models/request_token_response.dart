class RequestTokenResponse {
  RequestTokenResponse({
    required this.success,
    required this.expiresAt,
    required this.requestToken,
  });

  factory RequestTokenResponse.fromJson(Map<String, dynamic> json) {
    return RequestTokenResponse(
      success: json['success'] as bool? ?? false,
      expiresAt: json['expires_at'] as String? ?? '',
      requestToken: json['request_token'] as String? ?? '',
    );
  }

  final bool success;
  final String expiresAt;
  final String requestToken;
}
