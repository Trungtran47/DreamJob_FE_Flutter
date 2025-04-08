import 'package:dacn2/data/models/company.dart';
import 'package:dacn2/ui/widget/CustomDateField.dart';
import 'package:dacn2/ui/widget/CustomTextField.dart';
import 'package:dacn2/ui/widget/LocationDropdown.dart';
import 'package:dacn2/ui/widget/custom_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:dacn2/data/services/post_service.dart';
import 'package:dacn2/data/models/post.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn2/data/models/user.dart';
import 'package:dacn2/data/services/user_service.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final PostService postService = PostService(baseUrl: Util.baseUrl);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _vacanciesController = TextEditingController();
  String? _gender;
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _applicationRequirementsController =
      TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _workLocationController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  DateTime? _expirationDate;
  String? _selectedLocation;
  String? _selectedlevel;
  String? _selectedemploymentType;
  String? _selectedExperience;
  String? _selectedSalary;
  late int userId;
  final UserService userService = UserService(baseUrl: Util.baseUrl);

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;
      final user = await userService.getUserById(userId);

      try {
        final vacancies = int.parse(_vacanciesController.text);
        // if (_formKey.currentState?.validate() ?? false) {
        final post = Post(
          postId: 0,
          user: user,
          title: _titleController.text,
          salary: _selectedSalary ?? '',
          location: _selectedLocation ?? '',
          experience: _selectedExperience ?? '',
          employmentType: _selectedemploymentType ?? '',
          vacancies: vacancies,
          gender: _gender ?? '',
          level: _selectedlevel ?? '',
          jobDescription: _jobDescriptionController.text,
          applicationRequirements: _applicationRequirementsController.text,
          benefits: _benefitsController.text,
          workLocation: _workLocationController.text,
          workingHours: _workingHoursController.text,
          postedDate: DateTime.now(),
          expirationDate: _expirationDate ?? DateTime.now(),
        );

        await postService.savePost(post);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bài post đã được tạo thành công')),
        );
        Navigator.pop(context, true);
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
        //   );
        // }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo bài post: $e')),
        );
      }
    }
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Màu nhạt ở trên
                const Color.fromARGB(
                    255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
                Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: Text('Tạo bài post'),
        backgroundColor: Color(0xFF039BE5), // Xanh đậm
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Tiêu đề',
              ),
              CustomDropdownField(
                value: _selectedSalary,
                label: 'Lương',
                items: [
                  'Thỏa thuận',
                  'Dưới 5 triệu',
                  '5-10 triệu',
                  '10-20 triệu',
                  '20-50 triệu',
                  'Trên 50 triệu'
                ],
                onChanged: (value) => setState(() => _selectedSalary = value),
              ),
              CustomDropdownField(
                value: _selectedExperience,
                label: 'Kinh nghiệm',
                items: [
                  'Không yêu cầu',
                  'Dưới 1 năm',
                  '1-2 năm',
                  '2-5 năm',
                  'Trên 5 năm'
                ],
                onChanged: (value) =>
                    setState(() => _selectedExperience = value),
              ),
              CustomDropdownField(
                value: _selectedemploymentType,
                label: 'Hình thức',
                items: [
                  'Từ xa',
                  'Toàn thời gian',
                  'Bán thời gian',
                ],
                onChanged: (value) =>
                    setState(() => _selectedemploymentType = value),
              ),
              CustomTextField(
                controller: _vacanciesController,
                label: 'Số lượng tuyển dụng',
                keyboardType: TextInputType.number,
              ),
              CustomDropdownField(
                label: 'Chọn giới tính',
                value: _gender,
                items: ['Nam', 'Nữ', 'Nam và Nữ', 'Không yêu cầu'],
                onChanged: (value) => setState(() => _gender = value),
              ),
              LocationDropdown(
                selectedLocation: _selectedLocation,
                onLocationChanged: (newLocation) {
                  setState(() {
                    _selectedLocation = newLocation;
                  });
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _workLocationController,
                label: 'Địa điểm làm việc',
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              CustomTextField(
                controller: _workingHoursController,
                label: 'Giờ làm việc',
              ),
              CustomDropdownField(
                value: _selectedlevel,
                label: 'Cấp bậc',
                items: [
                  'Nhân viên',
                  'Trưởng phòng',
                  'Quản lý',
                  'Giám đốc',
                  'Tổng giám đốc',
                  'Chủ tịch',
                  'Khác',
                ],
                onChanged: (value) => setState(() => _selectedlevel = value),
              ),
              CustomTextField(
                controller: _jobDescriptionController,
                label: 'Mô tả công việc',
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              CustomTextField(
                controller: _applicationRequirementsController,
                label: 'Yêu cầu ứng tuyển',
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              CustomTextField(
                controller: _benefitsController,
                label: 'Quyền lợi',
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              CustomDateField(
                label: 'Ngày hết hạn',
                onTap: () => _selectExpirationDate(context),
                dateText: _expirationDate != null
                    ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                    : '',
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  iconColor: Color(0xFF039BE5),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Tạo bài post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
