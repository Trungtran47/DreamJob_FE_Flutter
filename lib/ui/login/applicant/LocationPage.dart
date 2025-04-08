import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  final Function(String) onSelected;

  LocationPage({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'Vị trí 1',
      'Vị trí 2',
      'Vị trí 3',
      // Thêm các gợi ý khác ở đây
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Vị trí công việc mong muốn'),
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
      ),
      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index]),
            onTap: () {
              onSelected(suggestions[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
