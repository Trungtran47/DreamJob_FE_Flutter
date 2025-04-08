class MessageRequest {
  final int applicantId;
  final String applicantName;
  final int employerId;
  final String employerName;
  final String avatarChat;
  final List<MessageDetail> messageDetails;

  MessageRequest({
    required this.applicantId,
    required this.applicantName,
    required this.employerId,
    required this.employerName,
    required this.avatarChat,
    required this.messageDetails,
  });

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'applicantId': applicantId,
      'applicantName': applicantName,
      'employerId': employerId,
      'employerName': employerName,
      'avatarChat': avatarChat,
      'messageDetails': messageDetails.map((e) => e.toJson()).toList(),
    };
  }

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      applicantId: json['applicantId'],
      applicantName: json['applicantName'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      avatarChat: json['avatarChat'],
      messageDetails: json['messageDetails']
          .map<MessageDetail>((e) => MessageDetail.fromJson(e))
          .toList(),
    );
  }
}

class MessageDetail {
  final int userId;
  final String content;
  final String cv;
  final String sendingTime;

  MessageDetail({
    required this.userId,
    required this.content,
    required this.cv,
    required this.sendingTime,
  });

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'cv': cv,
      'sendingTime': sendingTime,
    };
  }

  factory MessageDetail.fromJson(Map<String, dynamic> json) {
    return MessageDetail(
      userId: json['userId'],
      content: json['content'],
      cv: json['cv'],
      sendingTime: json['sendingTime'],
    );
  }
}
