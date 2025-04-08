import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          label,
          style: TextStyle(
            color: Colors.grey, // Màu chữ giống `LocationDropdown`
          ),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // Màu nền giống `LocationDropdown`
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey, // Màu chữ giống `LocationDropdown`
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.black, // Màu đường viền giống `LocationDropdown`
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.black, // Màu đường viền khi không chọn
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.black, // Màu đường viền khi focus
              width: 2.0,
            ),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: Colors.black, // Màu chữ trong danh sách dropdown
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Vui lòng chọn $label' : null,
      ),
    );
  }
}
