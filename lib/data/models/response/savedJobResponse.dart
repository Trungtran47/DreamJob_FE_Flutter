class SavedJobResponse {
  final int id;
  final int userId;

  SavedJobResponse({
    required this.id,
    required this.userId,
  });

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
    };
  }

  // Phương thức tạo đối tượng từ JSON
  factory SavedJobResponse.fromJson(Map<String, dynamic> json) {
    return SavedJobResponse(
      id: json['id'],
      userId: json['userId'],
    );
  }
}
