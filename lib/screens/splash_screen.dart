// Import the Flutter Material package, which provides various widgets and utilities for building Material Design apps.
import 'package:flutter/material.dart';

// Import the Lottie package to use animations in the app.
import 'package:lottie/lottie.dart';

// Import the Dart async package to use asynchronous programming features like Timer.
import 'dart:async';

// Import the login screen widget to navigate to after the splash screen.
import 'login_screen.dart';

// Define a stateful widget for the splash screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Define the state class for the SplashScreen widget.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Declare an animation controller and animation for the fade transition.
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a duration of 2 seconds.
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // Define the animation curve to ease in the opacity.
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    // Start the animation.
    _controller.forward();
    // Set a timer to navigate to the login screen after 3 seconds.
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller when the widget is disposed to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Scaffold to provide a basic material design visual layout structure.
      body: SizedBox(
        // Set the height and width to fill the screen.
        height: double.infinity,
        width: double.infinity,
        child: Center(
          // Center the FadeTransition widget in the screen.
          child: FadeTransition(
            // Apply the fade animation to the Lottie animation.
            opacity: _animation,
            child: Lottie.asset(
              // Load and display the Lottie animation from the specified asset path.
              'assets/animations/animation_slash.json',
              // Set the size of the animation.
              height: 200,
              width: 200,
              // Fit the animation within its bounds while maintaining its aspect ratio.
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
