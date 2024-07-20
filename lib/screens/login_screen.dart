// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await authService.verifyPhoneNumber(_phoneController.text);
//               },
//               child: const Text('Verify Phone Number'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               decoration: const InputDecoration(labelText: 'OTP'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 bool result =
//                     await authService.signInWithOTP(_otpController.text);
//                 if (result) {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()));
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Failed to sign in')));
//                 }
//               },

//               child: const Text('Sign In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_calling/screens/verification_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.orange.shade200,
                child: const Icon(
                  Icons.phone_iphone,
                  size: 40.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Hi there!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'To start working with the app\nwe need to verify your phone number.\nThis app will send an SMS message\nto your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Your phone',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 100.0),
              if (!isLoading) ...[
                ElevatedButton(
                  onPressed: () async {
                    isLoading = false;
                    setState(
                        () {}); // This updates the UI to show the CircularProgressIndicator

                    await authService.verifyPhoneNumber(
                        context, _phoneController.text);

                    isLoading = false;
                    setState(
                        () {}); // This updates the UI to hide the CircularProgressIndicator
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    backgroundColor: Colors.orange.shade100,
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
              if (isLoading == true) ...[
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
