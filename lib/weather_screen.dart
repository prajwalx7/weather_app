import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
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

    return {'weather': weatherData, 'forecast': forecastData};
  }

  String formatDateTime(String dateTime) {
    final parsedDateTime = DateTime.parse(dateTime);
    return DateFormat('d MMM').format(parsedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherData = getWeatherData();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
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
          final currentTemp =
              weather['main']['temp'].toInt(); 
          final weatherDescription = weather['weather'][0]['description'];
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
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp °C",
                                style: const TextStyle(fontSize: 32),
                              ),
                              const Icon(
                                Icons.foggy,
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
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        SmallCardWidget(
                          time:
                              formatDateTime(forecast['list'][i * 8]['dt_txt']),
                          icon: Icons.cloud,
                          temperature:
                              "${forecast['list'][i * 8]['main']['temp'].toInt()} °C",
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoWidget(
                        icon: Icons.water_drop,
                        text: "Humidity",
                        value: currentHumidity.toString()),
                    AdditionalInfoWidget(
                        icon: Icons.air,
                        text: "Wind Speed",
                        value: currentSpeed.toString()),
                    AdditionalInfoWidget(
                        icon: Icons.beach_access,
                        text: "Pressure",
                        value: currentPressure.toString())
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
