import 'package:flutter/material.dart';

class Weather extends StatelessWidget {
  final String imageData;
  final String temp;
  final String feels;
  final String details;

  const Weather({
    super.key,
    required this.imageData,
    required this.temp,
    required this.feels,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    // Define the positions and heights for each imageData value
    final Map<String, Map<String, double>> imageProperties = {
      'thunder': {'top': -225, 'right': -200, 'height': 500},
      'Rain': {'top': -50, 'right': 5, 'height': 150},
      'Clear': {'top': -100, 'right': -150, 'height': 200},
      'Clouds': {'top': -50, 'right': 5, 'height': 150},
      'snow': {'top': -50, 'right': 5, 'height': 150},
      'night': {'top': -50, 'right': 5, 'height': 125},
      'hot': {'top': -50, 'right': 5, 'height': 150},

    };

    // Default properties if imageData doesn't match any key
    final defaultProperties = {'top': -50.0, 'right': 5.0, 'height': 130.0};

    // Get the properties for the current imageData or use the default properties
    final properties = imageProperties[imageData] ?? defaultProperties;

    // Define the image asset paths
    final Map<String, String> imageAssets = {
      'thunder': 'assets/thunder.png',
      'Rain': 'assets/rain.png',
      'Clear': 'assets/clear_day.png',
      'Clouds': 'assets/cloudy.png',
      'snow': 'assets/snowing.png',
      'night': 'assets/full-moon.png',
      'hot':'assets/sun.png',
    };

    // Get the image asset path for the current imageData or use a default image
    final imagePath = imageAssets[imageData] ?? 'assets/thermometer.png';

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            gradient: const LinearGradient(
              colors: [Colors.blueGrey, Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset: const Offset(6, 6),
                color: Colors.grey.withOpacity(.9),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 10,
                left: 15,
                child: Text(
                  '$temp°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: properties['top']!.toDouble(),
                right: properties['right']!.toDouble(),
                child: Image.asset(
                  imagePath,
                  height: properties['height']!.toDouble(),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'Feels like $feels° / $details.',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
