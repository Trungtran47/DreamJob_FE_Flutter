import 'package:dacn2/data/util/Util.dart';

class Blog {
  final int? blogId;
  final int? user;
  final String title;
  final String content;
  final String? author;
  final String? image;
  final String? time;
  final int? status;
  Blog({
    this.blogId,
    this.user,
    required this.title,
    required this.content,
    this.author,
    this.image,
    this.time,
    this.status,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'],
      user: json['user'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      image: json['image'],
      time: json['time'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'blogId': blogId,
      'user': user,
      'title': title,
      'content': content,
      'author': author,
      'image': image,
      'time': time,
      'status': status,
    };
  }

  String get imageUrl =>
      Util.baseUrl + '/uploads/Blog/$image'; // Đường dẫn đến ảnh
  String statusBlog() {
    if (status == 0) {
      return 'Đã duyệt';
    } else {
      return 'Chưa duyệt';
    }
  }

  String getDays() {
    final parsedTime = DateTime.parse(time!);
    return 'Ngày đăng: ${parsedTime.day}/${parsedTime.month}/${parsedTime.year}';
  }

  String getDayApplicant() {
    final parsedTime = DateTime.parse(time!);
    return '${parsedTime.day}/${parsedTime.month}/${parsedTime.year}';
  }
}
