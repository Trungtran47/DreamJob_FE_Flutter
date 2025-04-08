import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/data/models/user.dart';

class Company {
  final int? companyId;
  final int? user;
  final String companyName;
  final String companyIntroduce;
  final String companyWebsite;
  final String companyLocation;
  final String companyCategory;
  final String companySize;
  final String companyLogo;

  Company({
    this.companyId,
    this.user,
    required this.companyName,
    required this.companyIntroduce,
    required this.companyWebsite,
    required this.companyLocation,
    required this.companyCategory,
    required this.companySize,
    required this.companyLogo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'] as int?,
      user: json['user'] ?? 0,
      companyName: json['companyName'] ?? '',
      companyIntroduce: json['companyIntroduce'] ?? '',
      companyWebsite: json['companyWebsite'] ?? '',
      companyLocation: json['companyLocation'] ?? '',
      companyCategory: json['companyCategory'] ?? '',
      companySize: json['companySize'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'user': user,
      'companyName': companyName,
      'companyIntroduce': companyIntroduce,
      'companyWebsite': companyWebsite,
      'companyLocation': companyLocation,
      'companyCategory': companyCategory,
      'companySize': companySize,
      'companyLogo': companyLogo,
    };
  }

  String get logoUrl =>
      Util.baseUrl + '/uploads/companies/$companyLogo'; // Đường dẫn đến ảnh
}
