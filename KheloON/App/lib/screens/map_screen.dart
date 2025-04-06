import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:health/health.dart';

class WalkingTracker extends StatefulWidget {
  @override
  _WalkingTrackerState createState() => _WalkingTrackerState();
}

class _WalkingTrackerState extends State<WalkingTracker> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  List<LatLng> _walkedPath = [];
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<AccelerometerEvent>? _accelerometerStream;
  bool _isTracking = false;
  bool _isPaused = false;
  int _steps = 0;
  double _distance = 0.0;
  double _speed = 0.0;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _activityType = 'Walking';
  
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  bool _initialized = false;
  double _stepThreshold = 0.24;
  int _timeThreshold = 500;
  int _lastStepTime = 0;
  double _alpha = 0.8;

  Health health = Health();

  @override
  void dispose() {
    _positionStream?.cancel();
    _accelerometerStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are permanently denied.")),
        );
        return;
      }
    }

    setState(() {
      _isTracking = true;
      _isPaused = false;
      _walkedPath.clear();
      _steps = 0;
      _distance = 0.0;
      _stopwatch.reset();
      _stopwatch.start();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position position) {
      if (!_isPaused) {
        setState(() {
          LatLng newPosition = LatLng(position.latitude, position.longitude);
          if (_currentPosition != null) {
            _distance += Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              newPosition.latitude,
              newPosition.longitude,
            );
          }
          _currentPosition = newPosition;
          _walkedPath.add(_currentPosition!);
          _speed = position.speed * 3.6;
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      }
    });

    _accelerometerStream = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_isPaused) {
        double x = _alpha * _lastX + (1 - _alpha) * event.x;
        double y = _alpha * _lastY + (1 - _alpha) * event.y;
        double z = _alpha * _lastZ + (1 - _alpha) * event.z;

        double delta = ((x - _lastX).abs() + (y - _lastY).abs() + (z - _lastZ).abs()) / 3;

        int now = DateTime.now().millisecondsSinceEpoch;
        if (_initialized && delta > _stepThreshold && now - _lastStepTime > _timeThreshold) {
          setState(() {
            _steps++;
            _lastStepTime = now;
          });
        }

        _lastX = x;
        _lastY = y;
        _lastZ = z;
        _initialized = true;
      }
    });
  }

  void _pauseTracking() {
    setState(() {
      _isPaused = true;
      _stopwatch.stop();
    });
  }

  void _resumeTracking() {
    setState(() {
      _isPaused = false;
      _stopwatch.start();
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _accelerometerStream?.cancel();
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _isTracking = false;
      _isPaused = false;
    });
  }

  Future<void> _saveToHealthConnect() async {
    bool granted = await health.requestAuthorization([
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA
    ], permissions: [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE]);

    bool success = false;
    if (granted) {
      bool stepsSuccess = await health.writeHealthData(
        value: _steps.toDouble(),
        type: HealthDataType.STEPS,
        startTime: DateTime.now().subtract(Duration(seconds: _stopwatch.elapsed.inSeconds)),
        endTime: DateTime.now(),
      );

      bool caloriesSuccess = await health.writeHealthData(
        value: _calculateCalories(),
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: DateTime.now().subtract(Duration(seconds: _stopwatch.elapsed.inSeconds)),
        endTime: DateTime.now(),
      );

      bool distanceSuccess = await health.writeHealthData(
        value: _distance,
        type: HealthDataType.DISTANCE_DELTA,
        startTime: DateTime.now().subtract(Duration(seconds: _stopwatch.elapsed.inSeconds)),
        endTime: DateTime.now(),
      );

      success = stepsSuccess && caloriesSuccess && distanceSuccess;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Data successfully saved to Health Connect" : "Failed to write data to Health Connect"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  double _calculateCalories() {
    // Adjust calorie calculation based on activity type
    double weight = 70; // Default weight in kg
    double calorieMultiplier = 0.04; // Base multiplier for walking
    double distanceMultiplier = 0.05; // Base multiplier for distance
    
    if (_activityType == 'Running') {
      calorieMultiplier = 0.08;
      distanceMultiplier = 0.1;
    } else if (_activityType == 'Cycling') {
      calorieMultiplier = 0.05;
      distanceMultiplier = 0.07;
    } else if (_activityType == 'Exercise') {
      calorieMultiplier = 0.06;
      distanceMultiplier = 0.08;
    }
    
    return (_steps * calorieMultiplier) + (_distance * distanceMultiplier * weight);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Tracker"),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('About Fitness Tracker'),
                  content: Text('Track your activities, monitor your progress, and sync with Health Connect.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Activity type selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue[600],
            child: Row(
              children: [
                Text('Activity Type:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _activityType,
                    dropdownColor: Colors.blue[500],
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: _isTracking ? null : (String? newValue) {
                      setState(() {
                        _activityType = newValue!;
                      });
                    },
                    items: <String>['Walking', 'Running', 'Cycling', 'Exercise']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: _isTracking ? Colors.grey : Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Map view
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(28.6139, 77.2090), zoom: 17),
              polylines: {
                Polyline(
                  polylineId: PolylineId("activityPath"),
                  points: _walkedPath,
                  color: Colors.blue,
                  width: 5,
                )
              },
              markers: _currentPosition != null
                  ? {Marker(markerId: MarkerId("current"), position: _currentPosition!)}
                  : {},
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              compassEnabled: true,
            ),
          ),
          
          // Stats panel
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 6,
                )
              ],
            ),
            child: Column(
              children: [
                // Activity duration
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _formatDuration(_stopwatch.elapsed),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                
                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Steps",
                        _steps.toString(),
                        Icons.directions_walk,
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        "Distance",
                        "${(_distance / 1000).toStringAsFixed(2)} km",
                        Icons.straighten,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Speed",
                        "${_speed.toStringAsFixed(1)} km/h",
                        Icons.speed,
                        Colors.orange,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        "Calories",
                        "${_calculateCalories().toStringAsFixed(0)} kcal",
                        Icons.local_fire_department,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                
                // Control buttons
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        _isTracking ? null : _startTracking,
                        "Start",
                        Icons.play_arrow,
                        Colors.green,
                      ),
                      _buildControlButton(
                        (_isTracking && !_isPaused) ? _pauseTracking : (_isTracking && _isPaused) ? _resumeTracking : null,
                        _isPaused ? "Resume" : "Pause",
                        _isPaused ? Icons.play_arrow : Icons.pause,
                        Colors.orange,
                      ),
                      _buildControlButton(
                        _isTracking ? _stopTracking : null,
                        "Stop",
                        Icons.stop,
                        Colors.red,
                      ),
                      _buildControlButton(
                        (_isTracking || _steps > 0) ? _saveToHealthConnect : null,
                        "Record",
                        Icons.save_alt,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(Function()? onPressed, String label, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}