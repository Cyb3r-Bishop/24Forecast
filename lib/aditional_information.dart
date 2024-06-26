import 'package:flutter/material.dart';

class ExtraInformation extends StatelessWidget {
  final String imagePath;
  final String value;
  final String label;
  final double imageHeight;
  final double imageWidth;

  const ExtraInformation({
    super.key,
    required this.imagePath,
    required this.value,
    required this.label,
    this.imageHeight = 40.0,
    this.imageWidth = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
