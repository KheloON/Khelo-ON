
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFF7F00);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
             // ignore: deprecated_member_use
            colors: [primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weight Loss Plan',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A 30-day plan to help you achieve your weight goals',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildDayCard(
                      context,
                      'Day 1',
                      [
                        'Breakfast: Oatmeal with berries',
                        'Lunch: Grilled chicken salad',
                        'Dinner: Baked salmon with vegetables',
                        'Snacks: Greek yogurt, almonds',
                      ],
                      primaryColor,
                    ),
                    _buildDayCard(
                      context,
                      'Day 2',
                      [
                        'Breakfast: Vegetable omelet',
                        'Lunch: Quinoa bowl with avocado',
                        'Dinner: Turkey and vegetable stir-fry',
                        'Snacks: Apple, protein shake',
                      ],
                      primaryColor,
                    ),
                    _buildDayCard(
                      context,
                      'Day 3',
                      [
                        'Breakfast: Smoothie bowl',
                        'Lunch: Lentil soup with whole grain bread',
                        'Dinner: Grilled fish with sweet potato',
                        'Snacks: Carrot sticks with hummus',
                      ],
                      primaryColor,
                    ),
                    _buildDayCard(
                      context,
                      'Day 4',
                      [
                        'Breakfast: Whole grain toast with avocado',
                        'Lunch: Chicken and vegetable wrap',
                        'Dinner: Bean and vegetable stew',
                        'Snacks: Mixed berries, nuts',
                      ],
                      primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, String day, List<String> meals, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: meals.map((meal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          meal,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
