import 'package:dacn2/data/util/Util.dart';

class User {
  final int userId;
  final String username;
  final String password;
  final String email;
  final String fullName;
  final int phone;
  final int roles;
  final String avatar;
  // final List<Post> post;
  final String cv;
  final String location;
  final String experience;
  final String desiredJob;
  // final Company? company; // Thêm thuộc tính company

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.roles,
    required this.avatar,
    // required this.post,
    required this.cv,
    required this.location,
    required this.experience,
    required this.desiredJob,
    // this.company, // Thêm thuộc tính company
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? 0,
      roles: json['roles'] ?? 0,
      avatar: json['avatar'] ?? '0',
      // post: json['posts'] != null
      //     ? (json['posts'] as List).map((e) => Post.fromJson(e)).toList()
      //     : [],
      cv: json['cv'] ?? '',
      location: json['location'] ?? '',
      experience: json['experience'] ?? '',
      desiredJob: json['desiredJob'] ?? '',
      // company: json['company'] != null
      //     ? Company.fromJson(json['company'])
      //     : null, // Thêm thuộc tính company
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'roles': roles,
      'avatar': avatar,
      // 'post': post,
      'cv': cv,
      'location': location,
      'experience': experience,
      'desiredJob': desiredJob,
      // 'company': company?.toJson(), // Thêm thuộc tính company
    };
  }

  User copyWith({
    int? userId,
    String? fullName,
    int? phone,
    String? avatar,
    String? username,
    String? password,
    String? email,
    int? roles,
    // List<Post>? post,
    String? cv,
    String? location,
    String? experience,
    String? desiredJob,
    // Company? company, // Thêm thuộc tính company
  }) {
    return User(
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      // post: post ?? this.post,
      cv: cv ?? this.cv,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      desiredJob: desiredJob ?? this.desiredJob,
      // company: company ?? this.company,
    );
  }

  String get cvUrl =>
      Util.baseUrl + '/uploads/companies/Cv/$cv'; // Đường dẫn đến ảnh

  String get fileCvUrl => Util.baseUrl + '/uploads/Cv/$cv'; // Đường dẫn đến ảnh
  String get avatarUrl =>
      Util.baseUrl + '/uploads/$avatar'; // Đường dẫn đến ảnh
}
