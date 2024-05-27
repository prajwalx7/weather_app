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

  Future getCurrentWeather() async {
    const cityName = 'London';
    final res = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName,uk&APPID=$openWeatherAPIKey"),
    );
    print(res.body);
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
              print("refresh");
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
        child: Padding(
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
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Text(
                              "28°C",
                              style: TextStyle(fontSize: 32),
                            ),
                            Icon(
                              Icons.foggy,
                              size: 64,
                            ),
                            Text(
                              "Rain",
                              style: TextStyle(fontSize: 24),
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
                        time: '09:00', icon: Icons.cloud, temperature: "30°C"),
                    SmallCardWidget(
                        time: '11:00', icon: Icons.sunny, temperature: "32°C"),
                    SmallCardWidget(
                        time: '13:00', icon: Icons.sunny, temperature: "29°C"),
                    SmallCardWidget(
                        time: '15:00', icon: Icons.foggy, temperature: "26°C"),
                    SmallCardWidget(
                        time: '17:00', icon: Icons.cloud, temperature: "24°C"),
                    SmallCardWidget(
                        time: '19:00', icon: Icons.sunny, temperature: "20°C"),
                    SmallCardWidget(
                        time: '21:00', icon: Icons.cloud, temperature: "18°C"),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoWidget(
                      icon: Icons.water_drop, text: "Humidity", value: "92"),
                  AdditionalInfoWidget(
                      icon: Icons.air, text: "Wind Speed", value: "7.5"),
                  AdditionalInfoWidget(
                      icon: Icons.beach_access, text: "Pressure", value: "1002")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
