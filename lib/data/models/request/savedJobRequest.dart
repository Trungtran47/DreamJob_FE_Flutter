class SavedJobRequest {
  final int id;
  final int userId;
  final int postId;

  SavedJobRequest({
    required this.id,
    required this.userId,
    required this.postId,
  });
  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
    };
  }

  // Phương thức tạo đối tượng từ JSON
  factory SavedJobRequest.fromJson(Map<String, dynamic> json) {
    return SavedJobRequest(
      id: json['id'],
      userId: json['userId'],
      postId: json['postId'],
    );
  }
}
