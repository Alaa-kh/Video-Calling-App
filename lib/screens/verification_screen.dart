import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:video_calling/main.dart';
import 'package:video_calling/services/auth_service.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            final double loginVerificationWidth =
                constraints.maxWidth > 700 ? 600 : double.infinity;
            return Align(
              alignment: Alignment.center,
              child: Container(
                width: loginVerificationWidth,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Confirm your phone number to log in.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => {},
                          child: const Text('Enter the code',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Pinput(
                      length: 6,
                      onCompleted: (pin) async {
                        bool result = await authService.signInWithOTP(pin);
                        if (result) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to sign in')));
                        }
                      },
                      preFilledWidget: const Text('-', style: TextStyle()),
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 48,
                        textStyle: const TextStyle(fontSize: 20),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(.1),
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
