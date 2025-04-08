import 'package:dacn2/data/util/Util.dart';

class ListMessageRespone {
  final int messageId;
  final int applicantId;
  final String applicantName;
  final int employerId;
  final String employerName;
  final String avatarChat;
  ListMessageRespone({
    required this.messageId,
    required this.applicantId,
    required this.applicantName,
    required this.employerId,
    required this.employerName,
    required this.avatarChat,
  });
  factory ListMessageRespone.fromJson(Map<String, dynamic> json) {
    return ListMessageRespone(
      messageId: json['messageId'],
      applicantId: json['applicantId'],
      applicantName: json['applicantName'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      avatarChat: json['avatarChat'] ?? 'default_avatar.png',
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['applicantId'] = this.applicantId;
    data['applicantName'] = this.applicantName;
    data['employerId'] = this.employerId;
    data['employerName'] = this.employerName;
    data['avatarChat'] = this.avatarChat;
    return data;
  }

  String get avatarUrl => Util.baseUrl + '/uploads/companies/$avatarChat';
}
