// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class GoogleMapPage extends StatefulWidget {
//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   GoogleMapController? mapController; // Nullable

//   LatLng _currentPosition = const LatLng(37.7749, -122.4194); // Vị trí mặc định
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // Lấy vị trí hiện tại
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Kiểm tra dịch vụ vị trí
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Nếu dịch vụ vị trí bị tắt
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng bật dịch vụ vị trí')),
//       );
//       return;
//     }

//     // Kiểm tra quyền truy cập vị trí
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Quyền truy cập vị trí bị từ chối vĩnh viễn')),
//       );
//       return;
//     }

//     // Lấy vị trí hiện tại
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       if (mapController != null) {
//         mapController!.animateCamera(
//           CameraUpdate.newLatLng(_currentPosition),
//         );
//       } else {
//         print("MapController chưa được khởi tạo.");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Maps'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentPosition,
//           zoom: 14.0,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           setState(() {
//             mapController = controller;
//           });
//         },

//         markers: {
//           Marker(
//             markerId: const MarkerId('currentLocation'),
//             position: _currentPosition,
//             infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
//           ),
//         },
//         myLocationEnabled: true, // Hiển thị nút vị trí hiện tại
//         myLocationButtonEnabled: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getCurrentLocation,
//         child: const Icon(Icons.location_searching),
//       ),
//     );
//   }
// }
