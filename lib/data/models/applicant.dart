import 'user.dart';
class Applicant {
  final int applicantId;
  final User user;
  final String cv;
  final String experience;
  final String location;
  final String desiredJob;
  final String imageLogo;

  Applicant({
    required this.applicantId,
    required this.user,
    required this.cv,
    required this.experience,
    required this.location,
    required this.desiredJob,
    required this.imageLogo,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      applicantId: json['applicant_id'],
      user: User.fromJson(json['user']),
      cv: json['cv'],
      experience: json['experience'],
      location: json['location'],
      desiredJob: json['desired_job'],
      imageLogo: json['image_logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
     
      'user': user.toJson(),
      'cv': cv,
      'experience': experience,
      'location': location,
      'desired_job': desiredJob,
      'image_logo': imageLogo,
    };
  }
}