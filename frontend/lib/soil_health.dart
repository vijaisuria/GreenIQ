import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SoilHealth extends StatefulWidget {
  @override
  _SoilHealthState createState() => _SoilHealthState();
}

class _SoilHealthState extends State<SoilHealth> {
  final String apiUrl = "https://api.thingspeak.com/channels/2758479/feeds.json?results=5";

  // Variables to hold data
  String latitude = "0.0";
  String longitude = "0.0";
  String latestSoilMoisture = "N/A";
  String latestTemperature = "N/A";
  String latestPressure = "N/A";
  String latestUpdateDate = "N/A";
  List<Map<String, dynamic>> pastValues = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Helper method to format the date
  String _formatDate(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return "N/A"; // Return "N/A" if timestamp is null or empty
    }
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal(); // Convert to local time
      return DateFormat("dd-MM-yyyy HH:mm").format(dateTime); // Format as HH:MM
    } catch (e) {
      return "Invalid Date"; // Return this if parsing fails
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('temperature', double.tryParse(latestTemperature) ?? 0.0);
    await prefs.setDouble('soilMoisture', double.tryParse(latestSoilMoisture) ?? 0.0);
    await prefs.setDouble('airHumidity', double.tryParse(latestPressure) ?? 0.0); // Assuming pressure maps to air humidity
    await prefs.setDouble('nitrogen', 120.0); // Placeholder for Nitrogen Content
    await prefs.setDouble('phosphorus', 60.0); // Placeholder for Phosphorus Content
    await prefs.setDouble('potassium', 150.0); // Placeholder for Potassium Content
    print("Data saved to SharedPreferences");
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Update latitude and longitude
        latitude = data['channel']['latitude'] ?? "0.0";
        longitude = data['channel']['longitude'] ?? "0.0";

        // Fetch feeds array
        final feeds = data['feeds'] as List;
        if (feeds.isNotEmpty) {
          // Extract the latest values
          final latestFeed = feeds.last;
          latestSoilMoisture = latestFeed['field1'] ?? "N/A";
          latestTemperature = latestFeed['field2'] ?? "N/A";
          latestPressure = latestFeed['field3'] ?? "N/A";
          latestUpdateDate = latestFeed['created_at'] ?? "N/A";

          // Extract past 5 values
          pastValues = feeds.map((feed) {
            return {
              "created_at": feed['created_at'] ?? "N/A",
              "moisture": feed['field1'] ?? "N/A",
              "temperature": feed['field2'] ?? "N/A",
              "pressure": feed['field3'] ?? "N/A",
            };
          }).toList().cast<Map<String, dynamic>>();

          // Save fetched data into SharedPreferences
          _saveToSharedPreferences();
        }

        // Update UI
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Page Title
              Text(
                'Crop Health Monitoring',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Location with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.yellow[700], size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Latitude: $latitude, Longitude: $longitude',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Main Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.water_drop, color: Colors.blue, size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    'Moisture',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('$latestSoilMoisture'),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.thermostat, color: Colors.red, size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    'Temperature',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('$latestTemperature'),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.speed, color: Colors.green, size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    'Pressure',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('$latestPressure'),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Last Updated: ${_formatDate(latestUpdateDate)}',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        icon: Icon(Icons.refresh, color: Colors.black),
                        onPressed: fetchData,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
