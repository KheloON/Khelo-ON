import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlanMacrosScreen extends StatefulWidget {
  const PlanMacrosScreen({super.key});

  @override
  State<PlanMacrosScreen> createState() => _PlanMacrosScreenState();
}

class _PlanMacrosScreenState extends State<PlanMacrosScreen> {
  final Map<String, dynamic> _currentMacros = {
    'calories': 2200,
    'protein': 140,
    'carbs': 220,
    'fat': 70,
  };
  
  final List<String> _goals = [
    'Weight Loss',
    'Maintenance',
    'Muscle Gain',
    'Athletic Performance',
    'Custom',
  ];
  
  String _selectedGoal = 'Weight Loss';
  
  final Map<String, List<Map<String, dynamic>>> _presets = {
    'Weight Loss': [
      {'name': 'Low Carb', 'protein': 35, 'carbs': 25, 'fat': 40},
      {'name': 'Balanced', 'protein': 30, 'carbs': 40, 'fat': 30},
      {'name': 'High Protein', 'protein': 40, 'carbs': 30, 'fat': 30},
    ],
    'Maintenance': [
      {'name': 'Balanced', 'protein': 30, 'carbs': 40, 'fat': 30},
      {'name': 'Zone Diet', 'protein': 30, 'carbs': 40, 'fat': 30},
      {'name': 'Mediterranean', 'protein': 25, 'carbs': 50, 'fat': 25},
    ],
    'Muscle Gain': [
      {'name': 'High Protein', 'protein': 40, 'carbs': 40, 'fat': 20},
      {'name': 'Balanced Bulk', 'protein': 30, 'carbs': 50, 'fat': 20},
      {'name': 'Clean Bulk', 'protein': 35, 'carbs': 45, 'fat': 20},
    ],
    'Athletic Performance': [
      {'name': 'Endurance', 'protein': 25, 'carbs': 60, 'fat': 15},
      {'name': 'Power', 'protein': 30, 'carbs': 40, 'fat': 30},
      {'name': 'Recovery', 'protein': 35, 'carbs': 50, 'fat': 15},
    ],
    'Custom': [
      {'name': 'Custom', 'protein': 30, 'carbs': 40, 'fat': 30},
    ],
  };
  
  Map<String, dynamic> _selectedPreset = {'name': 'Low Carb', 'protein': 35, 'carbs': 25, 'fat': 40};
  
  double _caloriesSliderValue = 2200;
  double _proteinPercentage = 35;
  double _carbsPercentage = 25;
  double _fatPercentage = 40;
  
  @override
  void initState() {
    super.initState();
    _updateMacroValues();
  }
  
  void _updateMacroValues() {
    setState(() {
      _proteinPercentage = _selectedPreset['protein'].toDouble();
      _carbsPercentage = _selectedPreset['carbs'].toDouble();
      _fatPercentage = _selectedPreset['fat'].toDouble();
      
      // Calculate actual grams based on percentages and calories
      _currentMacros['protein'] = (_caloriesSliderValue * _proteinPercentage / 100 / 4).round();
      _currentMacros['carbs'] = (_caloriesSliderValue * _carbsPercentage / 100 / 4).round();
      _currentMacros['fat'] = (_caloriesSliderValue * _fatPercentage / 100 / 9).round();
    });
  }
  
  void _updatePercentages(String macro, double value) {
    setState(() {
      switch (macro) {
        case 'protein':
          _proteinPercentage = value;
          // Adjust carbs and fat proportionally
          final remaining = 100 - _proteinPercentage;
          final ratio = _carbsPercentage / (_carbsPercentage + _fatPercentage);
          _carbsPercentage = remaining * ratio;
          _fatPercentage = remaining * (1 - ratio);
          break;
        case 'carbs':
          _carbsPercentage = value;
          // Adjust protein and fat proportionally
          final remaining = 100 - _carbsPercentage;
          final ratio = _proteinPercentage / (_proteinPercentage + _fatPercentage);
          _proteinPercentage = remaining * ratio;
          _fatPercentage = remaining * (1 - ratio);
          break;
        case 'fat':
          _fatPercentage = value;
          // Adjust protein and carbs proportionally
          final remaining = 100 - _fatPercentage;
          final ratio = _proteinPercentage / (_proteinPercentage + _carbsPercentage);
          _proteinPercentage = remaining * ratio;
          _carbsPercentage = remaining * (1 - ratio);
          break;
      }
      
      // Ensure percentages add up to 100
      final total = _proteinPercentage + _carbsPercentage + _fatPercentage;
      if (total != 100) {
        final factor = 100 / total;
        _proteinPercentage *= factor;
        _carbsPercentage *= factor;
        _fatPercentage *= factor;
      }
      
      // Update macros in grams
      _currentMacros['protein'] = (_caloriesSliderValue * _proteinPercentage / 100 / 4).round();
      _currentMacros['carbs'] = (_caloriesSliderValue * _carbsPercentage / 100 / 4).round();
      _currentMacros['fat'] = (_caloriesSliderValue * _fatPercentage / 100 / 9).round();
      
      // Update selected preset to custom
      _selectedGoal = 'Custom';
      _selectedPreset = {
        'name': 'Custom',
        'protein': _proteinPercentage,
        'carbs': _carbsPercentage,
        'fat': _fatPercentage,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Macros'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCaloriesSection(),
            const SizedBox(height: 20),
            _buildGoalSelector(),
            const SizedBox(height: 20),
            _buildPresetSelector(),
            const SizedBox(height: 20),
            _buildMacroDistribution(),
            const SizedBox(height: 20),
            _buildMacroSliders(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesSection() {
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
            'Daily Calories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_caloriesSliderValue.toInt()}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5722),
                ),
              ),
              const Text(
                ' calories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: _caloriesSliderValue,
            min: 1200,
            max: 4000,
            divisions: 56, // (4000-1200)/50
            activeColor: const Color(0xFFFF5722),
            inactiveColor: const Color(0xFFFF5722).withOpacity(0.2),
            label: '${_caloriesSliderValue.toInt()} cal',
            onChanged: (value) {
              setState(() {
                _caloriesSliderValue = value;
                _currentMacros['calories'] = value.toInt();
                
                // Update macros in grams
                _currentMacros['protein'] = (value * _proteinPercentage / 100 / 4).round();
                _currentMacros['carbs'] = (value * _carbsPercentage / 100 / 4).round();
                _currentMacros['fat'] = (value * _fatPercentage / 100 / 9).round();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1200 cal',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '4000 cal',
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
  }

  Widget _buildGoalSelector() {
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
            'Select Your Goal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final goal = _goals[index];
                final isSelected = goal == _selectedGoal;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGoal = goal;
                      _selectedPreset = _presets[goal]![0];
                      _updateMacroValues();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF5722) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        goal,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetSelector() {
    final presets = _presets[_selectedGoal]!;
    
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
            'Macro Presets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: presets.map((preset) {
              final isSelected = preset['name'] == _selectedPreset['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPreset = preset;
                    _updateMacroValues();
                  });
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF5722).withOpacity(0.1) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: const Color(0xFFFF5722), width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        preset['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFFFF5722) : Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'P: ${preset['protein']}% C: ${preset['carbs']}% F: ${preset['fat']}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroDistribution() {
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
            'Macro Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: MacroDistributionPainter(
                protein: _proteinPercentage,
                carbs: _carbsPercentage,
                fat: _fatPercentage,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroLegend('Protein', Colors.blue, '${_proteinPercentage.toInt()}%', '${_currentMacros['protein']}g'),
              _buildMacroLegend('Carbs', Colors.green, '${_carbsPercentage.toInt()}%', '${_currentMacros['carbs']}g'),
              _buildMacroLegend('Fat', Colors.orange, '${_fatPercentage.toInt()}%', '${_currentMacros['fat']}g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroLegend(String label, Color color, String percentage, String grams) {
    return Column(
      children: [
        Row(
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          grams,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroSliders() {
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
            'Adjust Macros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildMacroSlider('Protein', Colors.blue, _proteinPercentage, (value) {
            _updatePercentages('protein', value);
          }),
          const SizedBox(height: 15),
          _buildMacroSlider('Carbs', Colors.green, _carbsPercentage, (value) {
            _updatePercentages('carbs', value);
          }),
          const SizedBox(height: 15),
          _buildMacroSlider('Fat', Colors.orange, _fatPercentage, (value) {
            _updatePercentages('fat', value);
          }),
        ],
      ),
    );
  }

  Widget _buildMacroSlider(String label, Color color, double value, Function(double) onChanged) {
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
              '${value.toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: 10,
            max: 70,
            divisions: 60,
            activeColor: color,
            inactiveColor: color.withOpacity(0.2),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Save macro plan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Macro plan saved successfully!'),
              backgroundColor: Color(0xFFFF5722),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Save Macro Plan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MacroDistributionPainter extends CustomPainter {
  final double protein;
  final double carbs;
  final double fat;

  MacroDistributionPainter({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    
    final total = protein + carbs + fat;
    final proteinAngle = 2 * math.pi * (protein / total);
    final carbsAngle = 2 * math.pi * (carbs / total);
    final fatAngle = 2 * math.pi * (fat / total);
    
    var startAngle = -math.pi / 2;
    
    // Draw protein slice
    final proteinPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      proteinAngle,
      true,
      proteinPaint,
    );
    
    startAngle += proteinAngle;
    
    // Draw carbs slice
    final carbsPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      carbsAngle,
      true,
      carbsPaint,
    );
    
    startAngle += carbsAngle;
    
    // Draw fat slice
    final fatPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fatAngle,
      true,
      fatPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
