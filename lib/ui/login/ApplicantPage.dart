// import 'package:flutter/material.dart';
// import 'applicant/DesiredJobPage.dart';
// import 'applicant/ExperiencePage.dart';
// import 'applicant/LocationPage.dart';

// class ApplicantDetailsPage extends StatefulWidget {
//   @override
//   _ApplicantDetailsPageState createState() => _ApplicantDetailsPageState();
// }

// class _ApplicantDetailsPageState extends State<ApplicantDetailsPage> {
//   final _formKey = GlobalKey<FormState>();
//   String profileDescription = '';
//   String experience = '';
//   String desiredWorkPosition = '';
//   String desiredJob = '';
//   String status = '';
//   String resumeLink = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông tin chi tiết'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white, // Màu nhạt ở trên
//                 const Color.fromARGB(
//                     255, 149, 223, 255), // Màu nhạt hơn một chút ở giữa
//                 Colors.lightBlueAccent.shade400, // Màu đậm hơn ở dưới
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 20),
//               _buildTextField(
//                 label: 'Kinh nghiệm làm việc',
//                 icon: Icons.work,
//                 value: experience,
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ExperiencePage(
//                         onSelected: (value) {
//                           setState(() {
//                             experience = value;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 label: 'Vị trí công việc mong muốn',
//                 icon: Icons.business_center,
//                 value: desiredWorkPosition,
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LocationPage(
//                         onSelected: (value) {
//                           setState(() {
//                             desiredWorkPosition = value;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 label: 'Công việc mong muốn',
//                 icon: Icons.work_outline,
//                 value: desiredJob,
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DesiredJobPage(
//                         onSelected: (value) {
//                           setState(() {
//                             desiredJob = value;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               // const SizedBox(height: 20),
//               // _buildTextField(
//               //   label: 'Liên kết đến hồ sơ (CV)',
//               //   icon: Icons.link,
//               //   value: resumeLink,
//               //   onTap: () async {
//               //     final result = await Navigator.push(
//               //       context,
//               //       MaterialPageRoute(
//               //         builder: (context) => ResumeLinkPage(
//               //           onSelected: (value) {
//               //             setState(() {
//               //               resumeLink = value;
//               //             });
//               //           },
//               //         ),
//               //       ),
//               //     );
//               //   },
//               // ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     // Xử lý lưu thông tin chi tiết
//                     Navigator.pushReplacementNamed(context, '/homescreen');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 child: Text(
//                   'Lưu thông tin',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     required String value,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blueAccent.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: TextFormField(
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, color: Colors.blueAccent),
//             labelText: label,
//             labelStyle: TextStyle(
//               color: Colors.blueGrey,
//               fontSize: 16,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             enabled: false,
//           ),
//           initialValue: value,
//         ),
//       ),
//     );
//   }
// }
