import 'package:flutter/material.dart';
import 'package:health/health.dart';

class HealthConnectService {
  static final Health _health = Health();

  /// Configure Health API
  static Future<bool> configureHealth() async {
    try {
      await _health.configure();
      debugPrint("Health API configured successfully.");
      return true;
    } catch (e) {
      debugPrint("Error configuring Health API: $e");
      return false;
    }
  }

  /// Get the health data types we want to access
  static List<HealthDataType> get healthTypes => [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  /// Get the health permissions for read/write access
  static List<HealthDataAccess> get healthPermissions => [
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
  ];

  /// Check if we have permissions
  static Future<bool> hasPermissions() async {
    try {
      bool granted = await _health.hasPermissions(healthTypes, permissions: healthPermissions) ?? false;
      debugPrint(granted ? "Health Connect permissions already granted." : "Health Connect permissions NOT granted.");
      return granted;
    } catch (e) {
      debugPrint("Permission check failed: $e");
      return false;
    }
  }

  /// Request permissions for Health data access
  static Future<bool> requestPermissions() async {
    try {
      bool granted = await _health.requestAuthorization(healthTypes, permissions: healthPermissions);
      debugPrint(granted ? "Health Connect permissions granted!" : "Health Connect permissions were NOT granted!");
      return granted;
    } catch (e) {
      debugPrint("Error while requesting permissions: $e");
      return false;
    }
  }

  /// Fetch health data for a specific time range
  static Future<List<HealthDataPoint>> fetchHealthData({
    required DateTime startTime, 
    required DateTime endTime
  }) async {
    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startTime,
        endTime: endTime,
        types: healthTypes,
      );
      
      debugPrint("Fetched ${healthData.length} health data points.");
      
      // Log some details about the data we received
      if (healthData.isNotEmpty) {
        for (var type in healthTypes) {
          var pointsOfType = healthData.where((point) => point.type == type).toList();
          debugPrint("$type: ${pointsOfType.length} data points");
          
          if (pointsOfType.isNotEmpty) {
            for (var point in pointsOfType) {
              if (point.value is NumericHealthValue) {
                debugPrint("  - Value: ${(point.value as NumericHealthValue).numericValue}");
              }
            }
          }
        }
      }
      
      return healthData;
    } catch (e) {
      debugPrint("Error while fetching health data: $e");
      throw Exception("Failed to fetch health data: $e");
    }
  }
}
