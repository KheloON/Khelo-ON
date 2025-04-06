import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  final List<String> _weeks = [
    'Apr 24 - Apr 30',
    'Apr 17 - Apr 23',
    'Apr 10 - Apr 16',
    'Apr 3 - Apr 9',
  ];
  
  String _selectedWeek = 'Apr 24 - Apr 30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: _selectedWeek,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedWeek = value!;
                    });
                  },
                  items: _weeks.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Summary card
              _buildSummaryCard(),
              
              const SizedBox(height: 24),
              
              // Activity breakdown
              const Text(
                'Activity Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityBreakdown(),
              
              const SizedBox(height: 24),
              
              // Daily progress
              const Text(
                'Daily Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDailyProgress(),
              
              const SizedBox(height: 24),
              
              // Performance metrics
              const Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPerformanceMetrics(),
              
              const SizedBox(height: 24),
              
              // Achievements
              const Text(
                'Achievements This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildAchievements(),
              
              const SizedBox(height: 24),
              
              // Recommendations
              const Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildRecommendations(),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Distance', '42.5', 'km'),
              _buildSummaryItem('Time', '5:30', 'hours'),
              _buildSummaryItem('Calories', '3,250', 'kcal'),
            ],
          ),
          const SizedBox(height: 20),
          const LinearProgressIndicator(
            value: 0.85,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            minHeight: 8,
          ),
          const SizedBox(height: 10),
          const Text(
            '85% of weekly goal completed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityBreakdown() {
    final activities = [
      {'name': 'Running', 'percentage': 0.45, 'color': Colors.blue},
      {'name': 'Cycling', 'percentage': 0.25, 'color': Colors.green},
      {'name': 'Swimming', 'percentage': 0.15, 'color': Colors.purple},
      {'name': 'Strength', 'percentage': 0.15, 'color': Colors.orange},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: const Size(double.infinity, 180),
              painter: PieChartPainter(
                activities.map((a) => a['percentage'] as double).toList(),
                activities.map((a) => a['color'] as Color).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: activity['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      activity['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${((activity['percentage'] as double) * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgress() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [5.2, 7.8, 0.0, 6.3, 8.5, 10.2, 4.5]; // km per day
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          SizedBox(
            height: 200,
            child: BarChart(
              days: days,
              values: values,
              barColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Distance: ${values.reduce((a, b) => a + b).toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Avg: ${(values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1)} km/day',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final metrics = [
      {
        'name': 'Average Pace',
        'value': '7:30 min/mile',
        'change': '+3%',
        'improved': true,
      },
      {
        'name': 'Average Heart Rate',
        'value': '145 bpm',
        'change': '-2%',
        'improved': true,
      },
      {
        'name': 'Cadence',
        'value': '172 spm',
        'change': '+1%',
        'improved': true,
      },
      {
        'name': 'Elevation Gain',
        'value': '850 m',
        'change': '-5%',
        'improved': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: metrics.map((metric) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      metric['value'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (metric['improved'] as bool)
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (metric['improved'] as bool)
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14,
                        color: (metric['improved'] as bool) ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        metric['change'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (metric['improved'] as bool) ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'title': 'Personal Best',
        'description': 'Fastest 10K time: 45:30',
        'icon': Icons.emoji_events,
      },
      {
        'title': 'Consistency',
        'description': '5 days active streak',
        'icon': Icons.repeat,
      },
      {
        'title': 'Distance Record',
        'description': 'Longest run: 15 miles',
        'icon': Icons.straighten,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: achievements.map((achievement) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        achievement['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = [
      {
        'title': 'Rest Day',
        'description': 'Schedule a rest day after your long run',
        'icon': Icons.hotel,
      },
      {
        'title': 'Increase Mileage',
        'description': 'Gradually increase your weekly mileage by 10%',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Cross Training',
        'description': 'Add more swimming sessions for recovery',
        'icon': Icons.pool,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: recommendations.map((recommendation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    recommendation['icon'] as IconData,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        recommendation['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  PieChartPainter(this.percentages, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    var startAngle = -math.pi / 2;
    
    for (var i = 0; i < percentages.length; i++) {
      final sweepAngle = 2 * math.pi * percentages[i];
      
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i];
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BarChart extends StatelessWidget {
  final List<String> days;
  final List<double> values;
  final Color barColor;

  const BarChart({
    super.key,
    required this.days,
    required this.values,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: BarChartPainter(
        days: days,
        values: values,
        barColor: barColor,
        textColor: Colors.black87,
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<String> days;
  final List<double> values;
  final Color barColor;
  final Color textColor;

  BarChartPainter({
    required this.days,
    required this.values,
    required this.barColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = size.width / (days.length * 2);
    final double maxValue = values.reduce((curr, next) => curr > next ? curr : next);
    final double bottomPadding = 30;
    final double chartHeight = size.height - bottomPadding;

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(0, chartHeight),
      Offset(size.width, chartHeight),
      axisPaint,
    );

    // Draw bars and labels
    for (int i = 0; i < days.length; i++) {
      final double barHeight = values[i] / maxValue * chartHeight;
      final double barLeft = i * (size.width / days.length) + (size.width / days.length - barWidth) / 2;
      final double barTop = chartHeight - barHeight;

      // Draw bar
      final barPaint = Paint()
        ..color = barColor
        ..style = PaintingStyle.fill;
      
      final barRect = Rect.fromLTWH(barLeft, barTop, barWidth, barHeight);
      final barRRect = RRect.fromRectAndRadius(barRect, const Radius.circular(4));
      canvas.drawRRect(barRRect, barPaint);

      // Draw day label
      final textStyle = TextStyle(
        color: textColor,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: days[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          barLeft + barWidth / 2 - textPainter.width / 2,
          chartHeight + 10,
        ),
      );

      // Draw value label
      if (values[i] > 0) {
        final valueTextSpan = TextSpan(
          text: values[i].toStringAsFixed(1),
          style: textStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: barColor,
          ),
        );
        final valueTextPainter = TextPainter(
          text: valueTextSpan,
          textDirection: TextDirection.ltr,
        );
        valueTextPainter.layout();
        valueTextPainter.paint(
          canvas,
          Offset(
            barLeft + barWidth / 2 - valueTextPainter.width / 2,
            barTop - valueTextPainter.height - 5,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

