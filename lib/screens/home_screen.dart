import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_sensor/model/sounds_list.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AccelerometerEvent? accelerometerEvent;

  double dx = 100, dy = 100;
  @override
  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        print(event);
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Freesound"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Most popular new sounds"),
              FutureBuilder(
                  future: getSoundsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.results;
                      return ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Text(data[index].name);
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text("data");
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<GyroscopeEvent>(
                  stream: SensorsPlatform.instance.gyroscopeEventStream(),
                  builder: (_, snapShot) {
                    if (snapShot.hasData) {
                      dx = dx + (snapShot.data!.y * 10);
                      dy = dy + (snapShot.data!.x * 10);

                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: const CircleAvatar(
                          radius: 20,
                        ),
                      );
                    } else {
                      return Text("data");
                    }
                  })
            ],
          ),
        ),
      )),
    );
  }

  Future<SoundTopData> getSoundsList() async {
    final response = await http.get(Uri.parse(
        "https://freesound.org/apiv2/search/text/?query=beat&token=ZO8Ny9tMBLKCQw3DOAIhYD8glC9IUTkh8gnDGuQW"));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return SoundTopData.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load sound list');
    }
  }
}
