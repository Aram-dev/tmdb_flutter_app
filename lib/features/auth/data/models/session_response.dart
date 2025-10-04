class SessionResponse {
  SessionResponse({
    required this.success,
    required this.sessionId,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      success: json['success'] as bool? ?? false,
      sessionId: json['session_id'] as String? ?? '',
    );
  }

  final bool success;
  final String sessionId;
}
