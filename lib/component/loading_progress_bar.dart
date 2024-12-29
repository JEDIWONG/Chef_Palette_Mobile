import 'package:flutter/material.dart';

class LoadingProgressBar extends StatelessWidget {
  final bool isComplete; // Pass this flag to stop the animation when the order is complete

  const LoadingProgressBar({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return isComplete
        ? const SizedBox.shrink() // If the order is complete, show nothing
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Set the progress bar color to green
              backgroundColor: Colors.white, // Background color of the progress bar
              minHeight: 5, // Set the minimum height of the progress bar
            ),
          );
  }
}
