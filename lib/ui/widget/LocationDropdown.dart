import 'package:dacn2/data/services/province_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:flutter/material.dart';

class LocationDropdown extends StatefulWidget {
  final String? selectedLocation;
  final Function(String?) onLocationChanged;

  const LocationDropdown({
    Key? key,
    required this.selectedLocation,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  _LocationDropdownState createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  List<String> locations = [];
  String? selectedLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
    _getProvinces();
  }

  Future<void> _getProvinces() async {
    try {
      final response =
          await ProvinceService(baseUrl: Util.baseUrl).getAllProvinces();
      setState(() {
        locations = response
            .map((province) => province.provinceName as String)
            .toList(); // Giả sử mỗi Province có thuộc tính name là String

        // Nếu selectedLocation không có trong danh sách, đặt lại thành null
        if (selectedLocation != null && !locations.contains(selectedLocation)) {
          selectedLocation = null;
        }

        isLoading = false;
      });
    } catch (e) {
      print('Có lỗi xảy ra: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<String>(
              value: selectedLocation,
              decoration: InputDecoration(
                labelText: 'Chọn địa điểm',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
              ),
              items: locations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
                widget.onLocationChanged(newValue);
              },
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn địa điểm';
                }
                return null;
              },
              menuMaxHeight: 300.0, // Giới hạn chiều cao danh sách dropdown
            ),
    );
  }
}
