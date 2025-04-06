import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:io' show Platform;
import 'package:health/health.dart';
import 'Dashboardscreens/search_screen.dart';
import 'Dashboardscreens/my_calories_screen.dart';
import 'Dashboardscreens/plan_macros_screen.dart';
import 'Dashboardscreens/calendar_screen.dart';
// import 'health_screen.dart';
import 'package:athlete/services/health_connect_service.dart';
// import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  
  // Health data variables
  List<HealthDataPoint> healthData = [];
  bool isLoading = true;
  String errorMessage = '';
  
  // Daily totals
  double totalCalories = 0.0;
  double totalDistance = 0.0;
  int totalSteps = 0;
  
  // Progress targets
  final double _targetDistance = 10.0; // 10 km
  final int _targetSteps = 10000;
  final double _targetCalories = 2000.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Initialize health data
    initializeHealth();
    
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // Initialize health data
 Future<void> initializeHealth() async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    // Configure health service
    bool configured = await HealthConnectService.configureHealth();
    if (!configured) {
      setState(() {
        errorMessage = 'Failed to configure Health Connect';
        isLoading = false;
      });
      return;
    }

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
    debugPrint("Error initializing health: $e");
  }
}

// Update the fetchHealthData method with better error handling
Future<void> fetchHealthData() async {
  try {
    // Get today's date range
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    debugPrint("Fetching health data from ${startOfDay.toIso8601String()} to ${now.toIso8601String()}");
    
    // Fetch health data for today
    List<HealthDataPoint> data = await HealthConnectService.fetchHealthData(
      startTime: startOfDay,
      endTime: now,
    );

    if (mounted) {
      // Check if we actually got data
      if (data.isEmpty) {
        debugPrint("No health data found for today");
        setState(() {
          errorMessage = 'No health data available for today';
          isLoading = false;
        });
        return;
      }
      
      // Calculate daily totals
      calculateDailyTotals(data);
      
      setState(() {
        healthData = data;
        isLoading = false;
        // Clear error message since we successfully got data
        errorMessage = '';
      });
      
      // Debug log the calculated totals
      debugPrint("Updated UI with - Calories: $totalCalories, Distance: $totalDistance km, Steps: $totalSteps");
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        errorMessage = 'Error fetching health data: $e';
        isLoading = false;
      });
    }
    debugPrint("Error fetching health data: $e");
  }
}

 void calculateDailyTotals(List<HealthDataPoint> data) {
    double calories = 0.0;
    double distance = 0.0;
    int steps = 0;
    
    // Group data by type and sum up values
    for (var point in data) {
      if (point.value is NumericHealthValue) {
        final value = (point.value as NumericHealthValue).numericValue;
        
        if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          calories += value;
        } else if (point.type == HealthDataType.DISTANCE_DELTA) {
          distance += value;
        } else if (point.type == HealthDataType.STEPS) {
          steps += value.toInt();
        }
      }
    }
    
    // Convert distance from meters to kilometers
    distance = distance / 1000;
    
    // Update state variables
    totalCalories = calories;
    totalDistance = distance;
    totalSteps = steps;
    
    debugPrint("Daily Totals - Calories: $totalCalories, Distance: $totalDistance km, Steps: $totalSteps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFFF5722),
                          const Color(0xFFFF8A65).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Profile image and name
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
                                  ))
                                  .value,
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage("lib/assets/profile.png"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                                  ))
                                  .value,
                              child: Transform.translate(
                                offset: Offset(
                                  Tween<double>(begin: 50.0, end: 0.0)
                                      .animate(CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                                      ))
                                      .value,
                                  0,
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Alex',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      Tween<double>(begin: 50, end: 0)
                          .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
                          ))
                          .value,
                    ),
                    child: Opacity(
                      opacity: Tween<double>(begin: 0, end: 1)
                          .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.3, 1.0),
                          ))
                          .value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildDailyProgress(),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Features',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildFeatureGrid(),
                    const SizedBox(height: 25),
                    _buildRecentActivity(),
                    const SizedBox(height: 25),
                    _buildTips(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initializeHealth,
        backgroundColor: const Color(0xFFFF5722),
        child: const Icon(Icons.refresh),
      ),
    );
  }

 Future<bool> requestBasicPermissions() async {
  // Request basic device permissions
  var statuses = await [
    Permission.activityRecognition,
    Permission.location,
    Permission.sensors,
  ].request();

  // Check if basic permissions are granted
  bool basicPermissionsGranted = statuses.values.every((status) => status.isGranted);
  
  if (!basicPermissionsGranted) {
    return false;
  }
  
  // Now request Health Connect permissions
  try {
    bool healthPermissionsGranted = await HealthConnectService.requestPermissions();
    return healthPermissionsGranted;
  } catch (e) {
    debugPrint("Error requesting Health Connect permissions: $e");
    return false;
  }
}

// Now let's update the error widget in _buildDailyProgress() method
Widget _buildErrorWithRetry() {
  return Center(
    child: Column(
      children: [
        Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
              errorMessage = '';
            });
            
            try {
              // First, check if Health Connect is properly configured
              bool configured = await HealthConnectService.configureHealth();
              if (!configured) {
                setState(() {
                  isLoading = false;
                  errorMessage = 'Failed to configure Health Connect';
                });
                return;
              }
              
              // Force a new permission request
              bool granted = await HealthConnectService.requestPermissions();
              
              if (granted) {
                // If permissions granted, fetch health data
                await fetchHealthData();
              } else {
                // If permissions still not granted, show dialog
                if (mounted) {
                  setState(() {
                    isLoading = false;
                    errorMessage = 'Health Connect permissions required';
                  });
                  
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Permissions Required'),
                      content: const Text('Health Connect permissions are needed to track your fitness data. Would you like to open Health Connect settings?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            openHealthConnectSettings();
                          },
                          child: const Text('Open Settings'),
                        ),
                      ],
                    ),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                  errorMessage = 'Error: $e';
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
          ),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
// Update the openHealthConnectSettings method to properly open Health Connect
Future<void> openHealthConnectSettings() async {
  try {
    // Try to open Health Connect directly
    const healthConnectPackage = 'com.google.android.apps.healthdata';
    final Uri healthConnectUri = Uri.parse('package:$healthConnectPackage');
    
    if (await canLaunchUrl(healthConnectUri)) {
      await launchUrl(healthConnectUri);
    } else {
      // If direct opening fails, try to open Play Store
      final Uri playStoreUri = Uri.parse('market://details?id=$healthConnectPackage');
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri);
      } else {
        // If Play Store fails, open web URL
        await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=$healthConnectPackage'));
      }
    }
  } catch (e) {
    debugPrint("Error opening Health Connect settings: $e");
  }
}

// Now update the _buildDailyProgress method to use our new error widget
Widget _buildDailyProgress() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${DateTime.now().toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF5722),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        isLoading 
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5722)),
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorWithRetry()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProgressItem(
                        icon: Icons.local_fire_department,
                        value: totalCalories.toStringAsFixed(0),
                        label: 'Calories',
                        progress: totalCalories / _targetCalories,
                        color: const Color(0xFFFF5722),
                      ),
                      _buildProgressItem(
                        icon: Icons.directions_walk,
                        value: '${totalDistance.toStringAsFixed(2)} km',
                        label: 'Distance',
                        progress: totalDistance / _targetDistance,
                        color: Colors.blue,
                      ),
                      _buildProgressItem(
                        icon: Icons.directions_walk,
                        value: totalSteps.toString(),
                        label: 'Steps',
                        progress: totalSteps / _targetSteps,
                        color: Colors.green,
                      ),
                    ],
                  ),
      ],
    ),
  );
}
  Widget _buildProgressItem({required IconData icon, required String value, required String label, required double progress, required Color color}) {
    // Ensure progress is between 0.0 and 1.0
    final clampedProgress = progress.clamp(0.0, 1.0);
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Progress indicator
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                value: clampedProgress,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 5,
              ),
            ),
            // Icon
            Icon(icon, size: 24, color: color),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value, 
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(height: 2),
        Text(
          label, 
          style: TextStyle(
            fontSize: 12, 
            color: Colors.grey[600]
          )
        ),
      ],
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': 'Search',
        'icon': Icons.search,
        'screen': const SearchScreen(),
        'color': Colors.purple,
      },
      {
        'title': 'My Calories',
        'icon': Icons.local_fire_department,
        'screen': const MyCaloriesScreen(),
        'color': Colors.orange,
      },
      {
        'title': 'Plan Macros',
        'icon': Icons.pie_chart,
        'screen': const PlanMacrosScreen(),
        'color': Colors.green,
      },
      {
        'title': 'Calendar',
        'icon': Icons.calendar_month,
        'screen': CalendarScreen(),
        'color': Colors.blue,
      },
      {
        'title': 'Weekly Activity',
        'icon': Icons.bar_chart,
        // 'screen': const WeeklyActivityScreen(),
        'color': Colors.red,
      },
      {
        'title': 'Community',
        'icon': Icons.people,
        // 'screen': const CommunityScreen(),
        'color': Colors.teal,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return GestureDetector(
          onTap: () => _navigateToScreen(context, feature['screen'] as Widget),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'Morning Run',
        'time': '07:30 AM',
        'calories': '320',
        'icon': Icons.directions_run,
      },
      {
        'title': 'Breakfast',
        'time': '08:15 AM',
        'calories': '450',
        'icon': Icons.restaurant,
      },
      {
        'title': 'Gym Workout',
        'time': '06:00 PM',
        'calories': '580',
        'icon': Icons.fitness_center,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFFFF5722),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: const Color(0xFFFF5722),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          activity['time'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${activity['calories']} cal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Burned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Health Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildTipCard(
                title: 'Hydration Importance',
                description: 'Drinking enough water is crucial for your metabolism and overall health.',
                color: Colors.blue,
                icon: Icons.water_drop,
              ),
              _buildTipCard(
                title: 'Protein Intake',
                description: 'Ensure you get enough protein to support muscle recovery and growth.',
                color: Colors.green,
                icon: Icons.egg_alt,
              ),
              _buildTipCard(
                title: 'Sleep Quality',
                description: 'Good sleep is essential for recovery and maintaining a healthy weight.',
                color: Colors.purple,
                icon: Icons.nightlight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.7),
            color.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}