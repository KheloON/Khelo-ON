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
  int _steps = 0;
  double _distance = 0.0;
  double _speed = 0.0;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  bool _initialized = false;
  double _stepThreshold = 3.0;
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
    });

    _accelerometerStream = accelerometerEvents.listen((AccelerometerEvent event) {
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
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _accelerometerStream?.cancel();
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _isTracking = false;
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
        startTime: DateTime.now().subtract(Duration(seconds: 10)),
        endTime: DateTime.now(),
      );

      bool caloriesSuccess = await health.writeHealthData(
        value: _calculateCalories(),
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: DateTime.now().subtract(Duration(seconds: 10)),
        endTime: DateTime.now(),
      );

      bool distanceSuccess = await health.writeHealthData(
        value: _distance,
        type: HealthDataType.DISTANCE_DELTA,
        startTime: DateTime.now().subtract(Duration(seconds: 10)),
        endTime: DateTime.now(),
      );

      success = stepsSuccess && caloriesSuccess && distanceSuccess;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Data successfully saved to Health Connect" : "Failed to write data to Health Connect"),
      ),
    );
  }

  double _calculateCalories() {
    double weight = 70;
    return (_steps * 0.04) + (_distance * 0.05 * weight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Walking Tracker")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(28.6139, 77.2090), zoom: 15),
              polylines: {
                Polyline(
                  polylineId: PolylineId("walkingPath"),
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
            ),
          ),
          Text("Steps: $_steps"),
          Text("Distance: ${_distance.toStringAsFixed(2)} m"),
          Text("Speed: ${_speed.toStringAsFixed(2)} km/h"),
          Text("Calories: ${_calculateCalories().toStringAsFixed(2)} kcal"),
          ElevatedButton(onPressed: _isTracking ? null : _startTracking, child: Text("Start Tracking")),
          ElevatedButton(onPressed: _isTracking ? _stopTracking : null, child: Text("Stop Tracking")),
          ElevatedButton(onPressed: _saveToHealthConnect, child: Text("Save to Health Connect")),
        ],
      ),
    );
  }
}
