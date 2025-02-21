// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://placeholder.com/user'),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'You',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Progress/Activities tabs
                const DefaultTabController(
                  length: 2,
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Progress'),
                      Tab(text: 'Activities'),
                    ],
                  ),
                ),
                
                // Time period filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('7D'),
                        selected: true,
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('1M'),
                        selected: false,
                        onSelected: (bool selected) {},
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('3M'),
                        selected: false,
                        onSelected: (bool selected) {},
                      ),
                    ],
                  ),
                ),
                
                // Stats cards
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Distance',
                        value: '13.73 mi',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Time',
                        value: '2h 56m',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Elevation',
                        value: '920 ft',
                      ),
                    ),
                  ],
                ),
                
                // Progress chart
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 3),
                            const FlSpot(1, 2),
                            const FlSpot(2, 5),
                            const FlSpot(3, 3.1),
                            const FlSpot(4, 4),
                          ],
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Activity goals
                const SizedBox(height: 24),
                _ActivityGoal(
                  icon: Icons.directions_bike,
                  title: 'This week • 3 rides to go',
                  subtitle: '1/4 rides completed',
                ),
                const SizedBox(height: 16),
                _ActivityGoal(
                  icon: Icons.directions_run,
                  title: 'This week • 5 runs to go',
                  subtitle: '3/8 activities completed - Running',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityGoal extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActivityGoal({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}