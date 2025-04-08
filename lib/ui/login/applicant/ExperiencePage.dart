import 'package:flutter/material.dart';

class ExperiencePage extends StatelessWidget {
  final Function(String) onSelected;

  ExperiencePage({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'Kinh nghiệm 1',
      'Kinh nghiệm 2',
      'Kinh nghiệm 3',
      // Thêm các gợi ý khác ở đây
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kinh nghiệm làm việc'),
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
