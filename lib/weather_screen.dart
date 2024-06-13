import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const cityName = 'Aurangabad,MH,IN';
    final res = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$openWeatherAPIKey&units=metric"),
    );
    final data = jsonDecode(res.body);
    if (data['cod'] != 200) {
      throw 'An unexpected error occurred';
    }
    return data;
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
                getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCurrentWeather(),
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

          final data = snapshot.data!;
          final currentTemp = data['main']['temp'];
          final weatherDescription = data['weather'][0]['description'];
          final currentPressure = data['main']['pressure'];
          final currentHumidity = data['main']['humidity'];
          final currentSpeed = data['wind']['speed'];
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
                const SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SmallCardWidget(
                          time: '09:00',
                          icon: Icons.cloud,
                          temperature: "30°C"),
                      SmallCardWidget(
                          time: '11:00',
                          icon: Icons.sunny,
                          temperature: "32°C"),
                      SmallCardWidget(
                          time: '13:00',
                          icon: Icons.sunny,
                          temperature: "29°C"),
                      SmallCardWidget(
                          time: '15:00',
                          icon: Icons.foggy,
                          temperature: "26°C"),
                      SmallCardWidget(
                          time: '17:00',
                          icon: Icons.cloud,
                          temperature: "24°C"),
                      SmallCardWidget(
                          time: '19:00',
                          icon: Icons.sunny,
                          temperature: "20°C"),
                      SmallCardWidget(
                          time: '21:00',
                          icon: Icons.cloud,
                          temperature: "18°C"),
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
