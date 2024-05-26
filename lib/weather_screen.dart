import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
                              Icons.cloud,
                              size: 64,
                            ),
                            Text(
                              "Cloudy",
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
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
                    SmallCardWidget(),
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
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(60),
                child: const Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.water_drop, size: 32),
                        Text(
                          "Humidity",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "96",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Icon(Icons.wind_power, size: 32),
                        Text(
                          "data",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "9.66",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Icon(Icons.call_received_outlined, size: 32),
                        Text(
                          "data",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "1004",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SmallCardWidget extends StatelessWidget {
  const SmallCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(8.0),
        child: const Column(
          children: [
            Text(
              "09:00",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Icon(Icons.sunny),
            SizedBox(
              height: 8,
            ),
            Text("35°C"),
          ],
        ),
      ),
    );
  }
}
