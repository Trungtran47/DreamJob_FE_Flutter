import 'user.dart';

class Post {
  final int postId;
  final User user;
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

  Post({
    required this.postId,
    required this.user,
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      user: User.fromJson(json['user']),
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
      postedDate: DateTime.parse(json['postedDate'].toString()),
      expirationDate: DateTime.parse(json['expirationDate'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'user': user.toJson(),
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
    };
  }


}
