
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthConnectService {
  static final Health _health = Health();

  /// Configure Health API
  static Future<void> configureHealth() async {
    try {
      await _health.configure();
      debugPrint("Health API configured successfully.");
    } catch (e) {
      debugPrint("Error configuring Health API: $e");
    }
  }

  /// Request permissions for Health data access
  static Future<bool> requestPermissions() async {
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.HEART_RATE,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];

      bool granted = await _health.requestAuthorization(types);
      debugPrint(granted ? "Health Connect permissions granted!" : "Health Connect permissions were NOT granted!");
      return granted;
    } catch (e) {
      debugPrint("Error while requesting permissions: $e");
      return false;
    }
  }

  /// Fetch health data from the past 24 hours
  static Future<List<HealthDataPoint>> fetchHealthData({required DateTime startTime, required DateTime endTime}) async {
    try {
      DateTime now = DateTime.now();
      DateTime yesterday = now.subtract(const Duration(days: 1));

      List<HealthDataType> types = [
        HealthDataType.STEPS,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.HEART_RATE,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: types,
      );
      debugPrint("Fetched ${healthData.length} health data points.");
      return healthData;
    } catch (e) {
      debugPrint("Error while fetching health data: $e");
      return [];
    }
  }

  /// Write multiple health data points
  static Future<bool> writeHealthData({required HealthDataType type, required double value}) async {
    try {
      DateTime now = DateTime.now();
      bool success = await _health.writeHealthData(
        value: value,
        type: type,
        startTime: now,
        endTime: now,
      );
      debugPrint(success ? "$type data written successfully!" : "Failed to write $type data.");
      return success;
    } catch (e) {
      debugPrint("Error while writing $type data: $e");
      return false;
    }
  }

  /// Write multiple health metrics in a batch
  static Future<bool> writeAllHealthData() async {
    List<bool> results = await Future.wait([
      writeHealthData(type: HealthDataType.STEPS, value: 10),
      writeHealthData(type: HealthDataType.BLOOD_GLUCOSE, value: 3.1),
      writeHealthData(type: HealthDataType.HEART_RATE, value: 72),
      writeHealthData(type: HealthDataType.DISTANCE_DELTA, value: 500),
      writeHealthData(type: HealthDataType.ACTIVE_ENERGY_BURNED, value: 100),
    ]);

    return results.every((success) => success);
  }

  /// Get total steps for today
  static Future<int?> getTodaySteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);
      int? steps = await _health.getTotalStepsInInterval(midnight, now);
      debugPrint("Total steps today: ${steps ?? 0}");
      return steps;
    } catch (e) {
      debugPrint("Error while getting today's steps: $e");
      return null;
    }
  }
}