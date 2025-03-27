
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DietPlansScreen extends StatelessWidget {
  const DietPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFF7F00);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diet Plans',
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
                'Your Diet Plans',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildDietPlanCard(
                      context,
                      'Weight Loss Plan',
                      'A balanced diet plan to help you lose weight gradually and sustainably',
                      Icons.fitness_center,
                      primaryColor,
                    ),
                    _buildDietPlanCard(
                      context,
                      'Muscle Gain Plan',
                      'High protein diet to support muscle growth and recovery',
                      Icons.sports_gymnastics,
                      primaryColor,
                    ),
                    _buildDietPlanCard(
                      context,
                      'Balanced Nutrition',
                      'Well-rounded diet for overall health and wellness',
                      Icons.restaurant,
                      primaryColor,
                    ),
                    _buildDietPlanCard(
                      context,
                      'Vegetarian Plan',
                      'Plant-based diet rich in nutrients and protein alternatives',
                      Icons.eco,
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

  Widget _buildDietPlanCard(BuildContext context, String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                 // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
