import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // used for formatting the date

// components
import 'package:weather_app/components/additional_info_card.dart';
import 'package:weather_app/components/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // weather data
  // all the data will be stored in this variable
  late Future<Map<String, dynamic>> weather;

  // fetch the api data
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      String apiId = "Your Secret Api Id";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$apiId",
        ),
      );
      //print(res.body);

      final data = jsonDecode(res.body);

      // is the status code is not equal to 200.
      if (data['cod'] != '200') {
        // throws an exception
        throw "An unexpected error occurred";
      }
      return data; // if status code is 200

      // data['list'][0]['main']['temp'];
    } catch (err) {
      throw err.toString();
    }
  }

  // when the app loads
  @override
  void initState() {
    weather = getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // we use setState to refresh the app
              setState(() {
                // reload the app when tapped
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      // show the progress indicator till the actual temperature loads.
      body: FutureBuilder(
        future: weather,
        // snapshot is used to handle states
        builder: (context, snapshot) {
          // print(snapshot);
          // print(snapshot.runtimeType);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          // handling error's
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!; // data can be null

          final currentWeatherData = data["list"][0];
          final currentTemp = currentWeatherData["main"]["temp"];
          final currentSky = currentWeatherData["weather"][0]["main"];
          final currentPressure = currentWeatherData["main"]["pressure"];
          final windSpeed = currentWeatherData["wind"]["speed"];
          final humidity = currentWeatherData["main"]["humidity"];

          // temperature in degree celsius
          // convert degrees K into degrees C
          final tempInDegreeCelsius = currentTemp - 273.15;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // align all the column content to left side
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(255, 167, 164, 164),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "${tempInDegreeCelsius.toStringAsFixed(2)} °C",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // weather forecast cards
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data["list"][index + 1];
                      final hourlySky =
                          data["list"][index + 1]["weather"][0]["main"];
                      final hourlyTemp =
                          hourlyForecast["main"]["temp"].toString();
                      final time = DateTime.parse(hourlyForecast["dt_txt"]);
                      // convert the temperature in Kelvin to degrees Celsius
                      final hourlyTempInDegreeCelsius =
                          double.parse(hourlyTemp) - 273.15;
                      return ForecastCard(
                        // use j -: hour format
                        time: DateFormat.j().format(time),
                        temperature:
                            "${hourlyTempInDegreeCelsius.toStringAsFixed(1)} °C",
                        icon: hourlySky == "Clouds" || hourlySky == "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),
                // additional info
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCard(
                      label: 'Humidity',
                      icon: Icons.water_drop,
                      value: humidity.toString(),
                    ),
                    AdditionalInfoCard(
                      label: "Wind Speed",
                      icon: Icons.air,
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoCard(
                      label: "Pressure",
                      icon: Icons.beach_access,
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
