import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/constant.dart';
import 'package:weather_app/small_card_widget.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = getWeatherData();
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    const cityName = 'Aurangabad,MH,IN';
    final weatherResponse = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$openWeatherAPIKey&units=metric"),
    );
    final forecastResponse = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey&units=metric"),
    );

    if (weatherResponse.statusCode != 200 ||
        forecastResponse.statusCode != 200) {
      throw 'An unexpected error occurred';
    }

    final weatherData = jsonDecode(weatherResponse.body);
    final forecastData = jsonDecode(forecastResponse.body);

    // print("Current wather Data: $weatherData");
    // print("forecast : $forecastData");

    return {'weather': weatherData, 'forecast': forecastData};
  }

  String formatDateTime(String dateTime) {
    final parsedDateTime = DateTime.parse(dateTime);
    return DateFormat('d MMM').format(parsedDateTime);
  }

  IconData getWeatherIcon(String iconCode) {
    // Example mapping for Iconsax icons based on OpenWeatherMap icon codes
    switch (iconCode) {
      case '01d': // clear sky day
        return Iconsax.sun_15;
      case '01n': // clear sky night
        return Iconsax.cloud5;
      case '02d': // few clouds day
        return Iconsax.cloud_lightning;
      case '02n': // few clouds night
        return Iconsax.cloud_sunny5;
      case '03d': // scattered clouds day
      case '03n': // scattered clouds night
        return Iconsax.cloud5;
      case '04d': // broken clouds day
      case '04n': // broken clouds night
        return Iconsax.cloud_snow;
      case '09d': // shower rain day
      case '09n': // shower rain night
        return Iconsax.cloud_drizzle;
      case '10d': // rain day
      case '10n': // rain night
        return Iconsax.cloud5;
      case '11d': // thunderstorm day
      case '11n': // thunderstorm night
        return Iconsax.cloud_lightning;
      case '13d': // snow day
      case '13n': // snow night
        return Iconsax.cloud_snow;
      case '50d': // mist day
      case '50n': // mist night
        return Iconsax.cloud_fog;
      default:
        return Iconsax.cloud5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEEE),
      appBar: AppBar(
        backgroundColor: const Color(0xffEEEEEE),
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherData = getWeatherData();
              });
            },
            icon: const Icon(
              Iconsax.refresh,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          }

          final data = snapshot.data!;
          final weather = data['weather'];
          final forecast = data['forecast'];
          final currentTemp = weather['main']['temp'].toInt();
          final weatherDescription = weather['weather'][0]['description'];
          final weatherIconCode = weather['weather'][0]['icon'];
          final currentPressure = weather['main']['pressure'];
          final currentHumidity = weather['main']['humidity'];
          final currentSpeed = weather['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Text(
                              "$currentTemp °C",
                              style: const TextStyle(fontSize: 32),
                            ),
                            Icon(
                              getWeatherIcon(weatherIconCode),
                              size: 64,
                            ),
                            Text(
                              weatherDescription,
                              style: const TextStyle(fontSize: 24),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final hourlyData = forecast['list'][index * 3];
                      final hourlyTime = formatDateTime(hourlyData['dt_txt']);
                      final hourlyTemp = hourlyData['main']['temp'].toInt();
                      final hourlyWeatherIconCode =
                          hourlyData['weather'][0]['icon'];

                      return SmallCardWidget(
                        time: hourlyTime,
                        icon: getWeatherIcon(hourlyWeatherIconCode),
                        temperature: "$hourlyTemp °C",
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoWidget(
                          icon: Icons.water_drop_outlined,
                          text: "Humidity",
                          value: currentHumidity.toString()),
                      AdditionalInfoWidget(
                          icon: Iconsax.wind,
                          text: "Wind Speed",
                          value: currentSpeed.toString()),
                      AdditionalInfoWidget(
                          icon: Iconsax.weight,
                          text: "Pressure",
                          value: currentPressure.toString())
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
