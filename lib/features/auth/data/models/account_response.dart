class AccountResponse {
  AccountResponse({
    required this.id,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      id: json['id'] as int?,
    );
  }

  final int? id;
}
