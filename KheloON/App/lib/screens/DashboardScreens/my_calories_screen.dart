import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyCaloriesScreen extends StatefulWidget {
  const MyCaloriesScreen({super.key});

  @override
  State<MyCaloriesScreen> createState() => _MyCaloriesScreenState();
}

class _MyCaloriesScreenState extends State<MyCaloriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int _selectedDayIndex = 3; // Thursday (current day)
  
  final Map<String, dynamic> _calorieData = {
    'goal': 2200,
    'consumed': 1650,
    'burned': 420,
    'remaining': 970,
  };
  
  final List<Map<String, dynamic>> _meals = [
    {
      'name': 'Breakfast',
      'time': '08:30 AM',
      'calories': 450,
      'items': [
        {'name': 'Oatmeal with Berries', 'calories': 280, 'quantity': '1 bowl'},
        {'name': 'Greek Yogurt', 'calories': 100, 'quantity': '100g'},
        {'name': 'Black Coffee', 'calories': 5, 'quantity': '1 cup'},
        {'name': 'Almonds', 'calories': 65, 'quantity': '10g'},
      ],
    },
    {
      'name': 'Lunch',
      'time': '12:45 PM',
      'calories': 620,
      'items': [
        {'name': 'Grilled Chicken Salad', 'calories': 350, 'quantity': '1 serving'},
        {'name': 'Whole Grain Bread', 'calories': 120, 'quantity': '1 slice'},
        {'name': 'Olive Oil Dressing', 'calories': 120, 'quantity': '1 tbsp'},
        {'name': 'Apple', 'calories': 80, 'quantity': '1 medium'},
      ],
    },
    {
      'name': 'Snack',
      'time': '04:00 PM',
      'calories': 180,
      'items': [
        {'name': 'Protein Bar', 'calories': 180, 'quantity': '1 bar'},
      ],
    },
    {
      'name': 'Dinner',
      'time': '07:30 PM',
      'calories': 400,
      'items': [
        {'name': 'Salmon Fillet', 'calories': 250, 'quantity': '150g'},
        {'name': 'Steamed Broccoli', 'calories': 55, 'quantity': '100g'},
        {'name': 'Brown Rice', 'calories': 150, 'quantity': '100g'},
      ],
    },
  ];
  
  final Map<String, dynamic> _macros = {
    'protein': {'goal': 140, 'consumed': 110},
    'carbs': {'goal': 220, 'consumed': 180},
    'fat': {'goal': 70, 'consumed': 50},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calories'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFF5722),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFF5722),
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add food
        },
        backgroundColor: const Color(0xFFFF5722),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyView(),
          _buildWeeklyView(),
        ],
      ),
    );
  }

  Widget _buildDailyView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDaySelector(),
          const SizedBox(height: 20),
          _buildCaloriesSummary(),
          const SizedBox(height: 20),
          _buildMacronutrients(),
          const SizedBox(height: 20),
          _buildMealsList(),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 70,
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDayIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF5722) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _days[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${index + 10}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCaloriesSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories',
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
                  'Goal: ${_calorieData['goal']} cal',
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
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: CaloriesPainter(
                      consumed: _calorieData['consumed'] / _calorieData['goal'],
                      burned: _calorieData['burned'] / _calorieData['goal'],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_calorieData['remaining']}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5722),
                      ),
                    ),
                    const Text(
                      'cal remaining',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalorieInfoItem(
                label: 'Consumed',
                value: '${_calorieData['consumed']}',
                color: Colors.blue,
              ),
              _buildCalorieInfoItem(
                label: 'Burned',
                value: '${_calorieData['burned']}',
                color: Colors.green,
              ),
              _buildCalorieInfoItem(
                label: 'Net',
                value: '${_calorieData['consumed'] - _calorieData['burned']}',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieInfoItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '$value cal',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMacronutrients() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macronutrients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildMacroItem(
            label: 'Protein',
            consumed: _macros['protein']['consumed'],
            goal: _macros['protein']['goal'],
            color: Colors.blue,
            unit: 'g',
          ),
          const SizedBox(height: 15),
          _buildMacroItem(
            label: 'Carbs',
            consumed: _macros['carbs']['consumed'],
            goal: _macros['carbs']['goal'],
            color: Colors.green,
            unit: 'g',
          ),
          const SizedBox(height: 15),
          _buildMacroItem(
            label: 'Fat',
            consumed: _macros['fat']['consumed'],
            goal: _macros['fat']['goal'],
            color: Colors.orange,
            unit: 'g',
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem({
    required String label,
    required int consumed,
    required int goal,
    required Color color,
    required String unit,
  }) {
    final progress = consumed / goal;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$consumed/$goal $unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress > 1.0 ? 1.0 : progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Add meal
              },
              icon: const Icon(
                Icons.add,
                size: 16,
                color: Color(0xFFFF5722),
              ),
              label: const Text(
                'Add Meal',
                style: TextStyle(
                  color: Color(0xFFFF5722),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _meals.length,
          itemBuilder: (context, index) {
            final meal = _meals[index];
            return _buildMealCard(meal);
          },
        ),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getMealIcon(meal['name'] as String),
                color: const Color(0xFFFF5722),
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  meal['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${meal['calories']} cal',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5722),
              ),
            ),
            Text(
              '${(meal['items'] as List).length} items',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        children: [
          ...(meal['items'] as List).map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          item['quantity'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item['calories']} cal',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Edit meal
                },
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.grey,
                ),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Delete meal
                },
                icon: const Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.grey,
                ),
                label: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String mealName) {
    switch (mealName) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildWeeklyView() {
    final weeklyData = [
      {'day': 'Mon', 'consumed': 1800, 'burned': 350, 'goal': 2200},
      {'day': 'Tue', 'consumed': 2100, 'burned': 420, 'goal': 2200},
      {'day': 'Wed', 'consumed': 1950, 'burned': 380, 'goal': 2200},
      {'day': 'Thu', 'consumed': 1650, 'burned': 420, 'goal': 2200},
      {'day': 'Fri', 'consumed': 0, 'burned': 0, 'goal': 2200},
      {'day': 'Sat', 'consumed': 0, 'burned': 0, 'goal': 2200},
      {'day': 'Sun', 'consumed': 0, 'burned': 0, 'goal': 2200},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: WeeklyCaloriesChart(data: weeklyData),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('Consumed', Colors.blue),
                    const SizedBox(width: 20),
                    _buildLegendItem('Burned', Colors.green),
                    const SizedBox(width: 20),
                    _buildLegendItem('Goal', Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),
                _buildWeeklyStat(
                  label: 'Average Daily Calories',
                  value: '1,875',
                  unit: 'cal',
                  change: '+125',
                  isPositive: false,
                ),
                const SizedBox(height: 15),
                _buildWeeklyStat(
                  label: 'Total Calories Burned',
                  value: '1,570',
                  unit: 'cal',
                  change: '+320',
                  isPositive: true,
                ),
                const SizedBox(height: 15),
                _buildWeeklyStat(
                  label: 'Calorie Deficit',
                  value: '1,230',
                  unit: 'cal',
                  change: '+450',
                  isPositive: true,
                ),
                const SizedBox(height: 15),
                _buildWeeklyStat(
                  label: 'Protein Average',
                  value: '105',
                  unit: 'g',
                  change: '-5',
                  isPositive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStat({
    required String label,
    required String value,
    required String unit,
    required String change,
    required bool isPositive,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              '$value $unit',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CaloriesPainter extends CustomPainter {
  final double consumed;
  final double burned;

  CaloriesPainter({required this.consumed, required this.burned});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 15.0;
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);
    
    // Consumed calories arc
    final consumedPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * consumed,
      false,
      consumedPaint,
    );
    
    // Burned calories arc
    final burnedPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2 + 2 * math.pi * consumed,
      2 * math.pi * burned,
      false,
      burnedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WeeklyCaloriesChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WeeklyCaloriesChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: WeeklyCaloriesChartPainter(data: data),
    );
  }
}

class WeeklyCaloriesChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  WeeklyCaloriesChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = 20;
    final double spacing = (size.width - barWidth * data.length) / (data.length + 1);
    final double maxValue = 2500; // Slightly higher than the goal for better visualization
    final double chartHeight = size.height - 40;
    
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 5; i++) {
      final y = chartHeight - (chartHeight * i / 5);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
      
      // Draw grid line labels
      final textStyle = TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      );
      final textSpan = TextSpan(
        text: '${(maxValue * i / 5).toInt()}',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height),
      );
    }
    
    // Draw bars and day labels
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double x = spacing + i * (barWidth + spacing);
      
      // Draw goal line
      final goalPaint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      
      final goalHeight = (item['goal'] as int) / maxValue * chartHeight;
      canvas.drawLine(
        Offset(x, chartHeight - goalHeight),
        Offset(x + barWidth, chartHeight - goalHeight),
        goalPaint,
      );
      
      // Draw consumed calories bar
      if (item['consumed'] > 0) {
        final consumedPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;
        
        final consumedHeight = (item['consumed'] as int) / maxValue * chartHeight;
        final consumedRect = Rect.fromLTWH(
          x,
          chartHeight - consumedHeight,
          barWidth,
          consumedHeight,
        );
        final consumedRRect = RRect.fromRectAndRadius(
          consumedRect,
          const Radius.circular(4),
        );
        canvas.drawRRect(consumedRRect, consumedPaint);
      }
      
      // Draw burned calories bar
      if (item['burned'] > 0) {
        final burnedPaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;
        
        final burnedHeight = (item['burned'] as int) / maxValue * chartHeight;
        final burnedRect = Rect.fromLTWH(
          x + barWidth / 3,
          chartHeight - burnedHeight,
          barWidth / 3,
          burnedHeight,
        );
        final burnedRRect = RRect.fromRectAndRadius(
          burnedRect,
          const Radius.circular(2),
        );
        canvas.drawRRect(burnedRRect, burnedPaint);
      }
      
      // Draw day label
      final textStyle = TextStyle(
        color: Colors.grey[800],
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
      final textSpan = TextSpan(
        text: item['day'] as String,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, chartHeight + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
