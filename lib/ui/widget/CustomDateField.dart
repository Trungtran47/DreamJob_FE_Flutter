import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String dateText;

  const CustomDateField({
    Key? key,
    required this.label,
    required this.onTap,
    required this.dateText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Gọi hàm `onTap` khi người dùng nhấn vào trường
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: const Color.fromARGB(255, 78, 178, 228), // Màu nền trường nhập liệu
            suffixIcon: Icon(Icons.calendar_today), // Biểu tượng lịch
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Bo góc cho trường
              borderSide: BorderSide.none, // Không có viền xung quanh
            ),
          ),
          controller: TextEditingController(text: dateText), // Hiển thị ngày hiện tại
          validator: (value) =>
              dateText.isEmpty ? 'Vui lòng chọn $label' : null, // Kiểm tra nếu ngày trống
        ),
      ),
    );
  }
}
