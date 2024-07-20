// import 'package:flutter/material.dart';
// import 'call_logs_screen.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // authService.signOut();
//               // Navigator.pushReplacement(context,
//               //     MaterialPageRoute(builder: (context) => LoginScreen()));
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => VideoCallScreen()));
//               },
//               child: const Text('Start Video Call'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => CallLogsScreen()));
//               },
//               child: const Text('View Call Logs'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
