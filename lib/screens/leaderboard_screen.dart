// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Leaderboards'),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  selected: true,
                  label: const Text('All-Time'),
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  selected: false,
                  label: const Text('All-Time (Men)'),
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  selected: false,
                  label: const Text('All-Time (Women)'),
                  onSelected: (bool selected) {},
                ),
              ],
            ),
          ),
          // Leaderboard list
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return LeaderboardItem(
                  rank: index + 1,
                  name: 'Athlete ${index + 1}',
                  time: '4:${27 + index}',
                  pace: '7:${21 + index}/mi',
                  date: 'March 8, 2024',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String time;
  final String pace;
  final String date;

  const LeaderboardItem({
    super.key,
    required this.rank,
    required this.name,
    required this.time,
    required this.pace,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: rank == 1 ? Colors.amber : Colors.grey[200],
        child: Text(rank.toString()),
      ),
      title: Text(name),
      subtitle: Text(date),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(pace, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}