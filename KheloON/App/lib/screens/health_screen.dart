import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:athlete/services/health_connect_service.dart';
import 'package:animations/animations.dart';
import 'dart:convert'; // Import for jsonDecode

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  List<HealthDataPoint> healthData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    initializeHealth();
  }

  Future<void> initializeHealth() async {
    try {
 
      await HealthConnectService.configureHealth();

      // Request permissions
      bool permissionsGranted = await HealthConnectService.requestPermissions();

      if (permissionsGranted) {
        // Fetch health data
        await fetchHealthData();
      } else {
        setState(() {
          errorMessage = 'Health Connect permissions not granted';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error initializing health data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchHealthData() async {
    try {
      List<HealthDataPoint> data = await HealthConnectService.fetchHealthData();

      if (mounted) {
        setState(() {
          healthData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching health data: $e';
        isLoading = false;
      });
    }
  }

  String getValue(HealthDataType type) {
    try {
      var data = healthData.firstWhere(
        (point) => point.type == type,
        orElse: () => HealthDataPoint(
          uuid: '', // Use empty string for uuid
          value: HealthValue.fromJson(jsonDecode('{"numericValue": 0}')), // Provide valid JSON
          type: type,
          unit: HealthDataUnit.NO_UNIT,
          dateFrom: DateTime.now(),
          dateTo: DateTime.now(),
          // platform: PlatformType., // Replace with your platform
          sourceId: "Unknown Device",
          sourceDeviceId:"Unknown Device",
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          // sourceId: "Unknown",
          sourceName: "Health Connect",
        ),
      );

      if (data.value is NumericHealthValue) {
        return (data.value as NumericHealthValue).numericValue.toStringAsFixed(1);
      }
      return "0.0";
    } catch (e) {
      debugPrint("Error getting value for $type: $e");
      return "0.0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Connect")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "HEALTH SUMMARY",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          itemCount: healthMetrics.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                          itemBuilder: (context, index) {
                            final metric = healthMetrics[index];
                            return HealthCard(
                              icon: metric['icon'] as IconData,
                              title: metric['title'] as String,
                              value: getValue(metric['type'] as HealthDataType) + (metric['unit'] as String),
                              color: metric['color'] as Color,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: initializeHealth,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const HealthCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      closedColor: color,
      closedBuilder: (context, action) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      openBuilder: (context, action) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text(
            "$title: $value",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> healthMetrics = [
  {
    "icon": Icons.directions_walk,
    "title": "STEPS",
    "type": HealthDataType.STEPS,
    "unit": "",
    "color": Colors.blueAccent,
  },
  {
    "icon": Icons.favorite_rounded,
    "title": "HEART RATE",
    "type": HealthDataType.HEART_RATE,
    "unit": " bpm",
    "color": Colors.redAccent,
  },
  {
    "icon": Icons.bloodtype,
    "title": "BLOOD GLUCOSE",
    "type": HealthDataType.BLOOD_GLUCOSE,
    "unit": " mg/dL",
    "color": Colors.deepPurpleAccent,
  },
  {
    "icon": Icons.directions_run,
    "title": "DISTANCE",
    "type": HealthDataType.DISTANCE_DELTA,
    "unit": " m",
    "color": Colors.greenAccent,
  },
  {
    "icon": Icons.local_fire_department,
    "title": "CALORIES",
    "type": HealthDataType.ACTIVE_ENERGY_BURNED,
    "unit": " kcal",
    "color": Colors.orangeAccent,
  },
];