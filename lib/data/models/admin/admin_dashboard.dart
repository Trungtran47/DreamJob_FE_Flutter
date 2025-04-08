class AdminDashboard {
  final int userCount;
  final int companyCount;
  final int blogCount;
  final int jobCount;
  final int applicantCount;

  AdminDashboard({
    required this.userCount,
    required this.companyCount,
    required this.blogCount,
    required this.jobCount,
    required this.applicantCount,
  });

  factory AdminDashboard.fromJson(Map<String, dynamic> json) {
    return AdminDashboard(
      userCount: json['userCount'],
      companyCount: json['companyCount'],
      blogCount: json['blogCount'],
      jobCount: json['jobCount'],
      applicantCount: json['applicantCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userCount': userCount,
      'companyCount': companyCount,
      'blogCount': blogCount,
      'jobCount': jobCount,
      'applicantCount': applicantCount,
    };
  }
}
