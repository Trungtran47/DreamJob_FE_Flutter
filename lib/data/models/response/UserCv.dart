class UserCv {
  final String userId;
  final String cv;

  UserCv({required this.userId, required this.cv});

  factory UserCv.fromJson(Map<String, dynamic> json) {
    return UserCv(
      userId: json['userId'],
      cv: json['cv'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cv': cv,
    };
  }
}
