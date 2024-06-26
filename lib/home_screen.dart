import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_meather/aditional_information.dart';
import 'package:my_meather/forecast.dart';
import 'package:my_meather/secrets.dart';
import 'package:my_meather/weather.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Dhaka';
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIkey'),
      );

      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw 'An Unexpected Error Occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final imageData;
          final temperature = currentWeatherData['main']['temp'];
          final feels = currentWeatherData['main']['feels_like'];
          final details = currentWeatherData['weather'][0]['description'];
          if (temperature >= 313) {
            imageData = 'hot';
          } else if (temperature <= 273) {
            imageData = 'snow';
          } else {
            imageData = currentWeatherData['weather'][0]['main'];
          }

          final weather = currentWeatherData['weather'][0]['main'];

          final WindSpeed = currentWeatherData['wind']['speed'].toString();
          final Humidity = currentWeatherData['main']['humidity'].toString();
          final DewPoint = (currentWeatherData['main']['pressure']-currentWeatherData['main']['temp_kf']-273).toString();
          final Pressure = currentWeatherData['main']['pressure'].toString();
          final Visibility = currentWeatherData['visibility'].toString();
          final WindGust = currentWeatherData['wind']['gust'].toString();
          final SeaLevel = currentWeatherData['main']['sea_level'].toString();
          final GroundLevel = currentWeatherData['main']['grnd_level'].toString();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_sharp,
                            size: 50,
                            color: Colors.purple.shade300,
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const ImageIcon(
                              AssetImage('icons/location.png'),
                              size: 35,
                            ),
                            label: Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade100,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            iconSize: 40,
                            icon: Image.asset(
                              'icons/refresh.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 15,
                      ),
                      child: Text(
                        'How was your day?',
                        style: TextStyle(
                          color: Colors.black.withOpacity(.6),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Weather(
                      imageData: imageData.toString(),
                      temp: (temperature - 273).toStringAsFixed(2),
                      feels: (feels - 273).toStringAsFixed(2),
                      details: details,
                    ),
                    const SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'Next 24 Hours',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final hourlyForecast = data['list'][index + 1];
                            final time = DateTime.parse(hourlyForecast['dt_txt']);
                            return HourlyForecastItem(
                              time: DateFormat.Hm().format(time),
                              image: ((hourlyForecast['weather'][0]['main'] == 'Rain')
                                  ? Image.asset('icons/raining.png')
                                  : ((hourlyForecast['weather'][0]['main'] == 'Clear')
                                  ? Image.asset('icons/sunny.png')
                                  : ((hourlyForecast['weather'][0]['main'] == 'Clouds')
                                  ? Image.asset('icons/clouds.png')
                                  : Image.asset('icons/lightning-bolt.png')))),
                              temperature: hourlyForecast['main']['temp'].toString(),
                              text: hourlyForecast['weather'][0]['main'].toString(),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const ExtraInformation(
                                    imagePath: 'icons/uv-index.png',
                                    value: 
                                    //'Very High',
                                    'Normal',
                                    label: 'UV index'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/windy.png',
                                    value: WindSpeed,
                                    label: 'Wind Speed'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/weather.png',
                                    value: Humidity,
                                    label: 'Humidity'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ExtraInformation(
                                    imagePath: 'icons/temperature.png',
                                    value: DewPoint,
                                    label: 'Dew Point'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/pressure.png',
                                    value: '$Pressure mb',
                                    label: 'Pressure'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/visible.png',
                                    value: '$Visibility km',
                                    label: 'Visibility'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ExtraInformation(
                                    imagePath: 'icons/strength.png',
                                    value: WindGust,
                                    label: 'Wind Gust'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/water-level.png',
                                    value: SeaLevel,
                                    label: 'Sea Level'),
                                const SizedBox(
                                  width: 10,
                                ),
                                ExtraInformation(
                                    imagePath: 'icons/ground.png',
                                    value: GroundLevel,
                                    label: 'Ground Level'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
