import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'profile-image',
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          child: const CircleAvatar(
                            radius: 58,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=300&q=80',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Mayank Singh',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Athlete Runner',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Personal Information
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.cake, 'Date of Birth', 'May 15, 1990'),
                _buildInfoRow(Icons.height, 'Height', '6\'2" (188 cm)'),
                _buildInfoRow(Icons.monitor_weight, 'Weight', '185 lbs (84 kg)'),
                _buildInfoRow(Icons.favorite, 'Blood Type', 'O+'),
              ]),
              
              const SizedBox(height: 25),
              
              // Contact Information
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.email, 'Email', 'ms921@gmail.com'),
                _buildInfoRow(Icons.phone, 'Phone', '+91 958452021'),
                _buildInfoRow(Icons.location_on, 'Address', '123 Srmcem Tiwariganj, Lucknow'),
              ]),
              
              const SizedBox(height: 25),
              
              // Athletic Information
              const Text(
                'Athletic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoCard([
                _buildInfoRow(Icons.sports, 'Sport', 'Running (Marathon)'),
                _buildInfoRow(Icons.emoji_events, 'Experience', '10+ years'),
                _buildInfoRow(Icons.speed, 'Personal Best', '2:45:30 (Marathon)'),
                _buildInfoRow(Icons.group, 'Coach', 'Kushal Shah'),
              ]),
              
              const SizedBox(height: 30),
              
              // Performance Metrics
              const Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildPerformanceMetrics(context),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMetricRow('Average Pace', '7:30 min/mile', 0.85, context),
          const SizedBox(height: 15),
          _buildMetricRow('Weekly Distance', '42.5 miles', 0.75, context),
          const SizedBox(height: 15),
          _buildMetricRow('Recovery Rate', 'Excellent', 0.9, context),
          const SizedBox(height: 15),
          _buildMetricRow('Endurance Level', 'Advanced', 0.8, context),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, double progress, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }
}

