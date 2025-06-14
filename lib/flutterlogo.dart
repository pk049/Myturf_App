import 'package:flutter/material.dart';

class MyTurfLogo extends StatelessWidget {
  final double fontSize;

  const MyTurfLogo({
    super.key,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "My" part with white text on green background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'My',
            style: TextStyle(
              color: Colors.black87,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // "Turf" part with green text on white background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Turf',
            style: TextStyle(
              color: const Color(0xFF0A9D56),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}