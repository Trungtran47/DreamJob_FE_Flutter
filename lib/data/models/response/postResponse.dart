import 'package:dacn2/data/util/Util.dart';

class PostResponse {
  final int postId;
  final String title;
  final String salary;
  final String location;
  final String experience;
  final String employmentType;
  final int vacancies;
  final String gender;
  final String level;
  final String jobDescription;
  final String applicationRequirements;
  final String benefits;
  final String workLocation;
  final String workingHours;
  final DateTime postedDate;
  final DateTime expirationDate;
  final int userId;
  final String username;
  final int companyId;
  final String companyName;
  final String companyIntroduce;
  final String companyLocation;
  final String companyWebsite;
  final String companyCategory;
  final String companySize;
  final String companyLogo;

  PostResponse({
    required this.postId,
    required this.title,
    required this.salary,
    required this.location,
    required this.experience,
    required this.employmentType,
    required this.vacancies,
    required this.gender,
    required this.level,
    required this.jobDescription,
    required this.applicationRequirements,
    required this.benefits,
    required this.workLocation,
    required this.workingHours,
    required this.postedDate,
    required this.expirationDate,
    required this.userId,
    required this.username,
    required this.companyId,
    required this.companyName,
    required this.companyIntroduce,
    required this.companyLocation,
    required this.companyWebsite,
    required this.companyCategory,
    required this.companySize,
    required this.companyLogo,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      postId: json['postId'],
      title: json['title'],
      salary: json['salary'],
      location: json['location'],
      experience: json['experience'],
      employmentType: json['employmentType'],
      vacancies: json['vacancies'],
      gender: json['gender'],
      level: json['level'],
      jobDescription: json['jobDescription'],
      applicationRequirements: json['applicationRequirements'],
      benefits: json['benefits'],
      workLocation: json['workLocation'],
      workingHours: json['workingHours'],
      postedDate: DateTime.parse(json['postedDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      userId: json['userId'],
      username: json['username'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyIntroduce: json['companyIntroduce'],
      companyLocation: json['companyLocation'],
      companyWebsite: json['companyWebsite'],
      companyCategory: json['companyCategory'],
      companySize: json['companySize'],
      companyLogo: json['companyLogo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'salary': salary,
      'location': location,
      'experience': experience,
      'employmentType': employmentType,
      'vacancies': vacancies,
      'gender': gender,
      'level': level,
      'jobDescription': jobDescription,
      'applicationRequirements': applicationRequirements,
      'benefits': benefits,
      'workLocation': workLocation,
      'workingHours': workingHours,
      'postedDate': postedDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'userId': userId,
      'username': username,
      'companyId': companyId,
      'companyName': companyName,
      'companyIntroduce': companyIntroduce,
      'companyLocation': companyLocation,
      'companyWebsite': companyWebsite,
      'companyCategory': companyCategory,
      'companySize': companySize,
      'companyLogo': companyLogo,
    };
  }

  String getDaysRemaining() {
    final now = DateTime.now();
    final difference = expirationDate.difference(now);

    if (difference.isNegative) {
      return 'Bài viết đã hết thời gian tuyển dụng'; // Trả về thông báo khi đã hết hạn
    }

    final daysRemaining = difference.inDays;
    final hoursRemaining =
        difference.inHours % 24; // Lấy số giờ còn lại sau khi trừ ngày
    final minutesRemaining =
        difference.inMinutes % 60; // Lấy số phút còn lại sau khi trừ giờ

    if (daysRemaining > 0) {
      return 'Còn $daysRemaining ngày để nộp CV';
    } else if (hoursRemaining > 0) {
      return 'Còn $hoursRemaining giờ $minutesRemaining phút để nộp CV';
    } else {
      return 'Còn $minutesRemaining phút để nộp CV'; // Khi còn ít hơn 1 giờ
    }
  }

  String get logoUrl => Util.baseUrl + '/uploads/companies/$companyLogo';
}
