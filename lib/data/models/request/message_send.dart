class MessageSend {
  final int messageId;
  final int userId;
  final String content;
  final String cv;
  final String sendingTime;

  MessageSend({
    required this.messageId,
    required this.userId,
    required this.content,
    required this.cv,
    required this.sendingTime,
  });

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'userId': userId,
      'content': content,
      'cv': cv,
      'sendingTime': sendingTime,
    };
  }

  factory MessageSend.fromJson(Map<String, dynamic> json) {
    return MessageSend(
      messageId: json['messageId'],
      userId: json['userId'],
      content: json['content'],
      cv: json['cv'],
      sendingTime: json['sendingTime'],
    );
  }
}
