import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum for different analysis types
enum AnalysisType {
  // ignore: constant_identifier_names
  DETECT_ALLERGENS,
  // ignore: constant_identifier_names
  DETAILED_NUTRIENT_INFO,
  // ignore: constant_identifier_names
  LEARN_ABOUT_FOOD,
  // ignore: constant_identifier_names
  FUN_FACTS,
  // ignore: constant_identifier_names
  GENERATE_DISH
}

class FoodDetection extends StatefulWidget {
  const FoodDetection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetectionState createState() => _FoodDetectionState();
}

class _FoodDetectionState extends State<FoodDetection> {
  File? _imageFile;
  dynamic _analysisResult;
  bool isLoading = false;
  AnalysisType _selectedAnalysisType = AnalysisType.DETAILED_NUTRIENT_INFO;

  // Define our theme colors
  final Color primaryColor = const Color(0xFFFF7F00); // Orange
  final Color secondaryColor = Colors.white;
  final Color accentColor = const Color(0xFFFFA500); // Light Orange

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _analysisResult = null;
      });
      _showAnalysisTypeDialog();
    }
  }

  void _showAnalysisTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Analysis Type',
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnalysisType.values.map((type) {
              return ListTile(
                title: Text(
                  _getAnalysisTypeName(type),
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedAnalysisType = type;
                  });
                  _uploadImage();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getAnalysisTypeName(AnalysisType type) {
    switch (type) {
      case AnalysisType.DETECT_ALLERGENS:
        return 'Detect Allergens';
      case AnalysisType.DETAILED_NUTRIENT_INFO:
        return 'Detailed Nutrient Info';
      case AnalysisType.LEARN_ABOUT_FOOD:
        return 'Learn About Food';
      case AnalysisType.FUN_FACTS:
        return 'Fun Facts';
      case AnalysisType.GENERATE_DISH:
        return 'Generate Dish';
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    
    setState(() {
      isLoading = true;
      _analysisResult = null;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://rajatmalviya-food-classifier-api.hf.space/analyze"),
    );
    
    // Add the file
    request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
    
    // Add the analysis type
    request.fields['analysis_type'] = _selectedAnalysisType.toString().split('.').last;

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      setState(() {
        isLoading = false;
        _analysisResult = json.decode(responseBody);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _analysisResult = {"error": "Network error: $e"};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
    children: [
      Text(
        'Food Analyzer',
        style: GoogleFonts.poppins(
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Analyze your food easily', // Small text
        style: GoogleFonts.poppins(
          color: secondaryColor.withOpacity(0.7),
          fontSize: 12, // Smaller text
        ),
      ),
    ],
  ),
  backgroundColor: primaryColor,
  elevation: 0,
),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // ignore: deprecated_member_use
                colors: [primaryColor.withOpacity(0.1), secondaryColor],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                           _buildInstructionSection(),
                           
                          if (_imageFile != null) ...[
                            _buildImageContainer(),
                            const SizedBox(height: 20),
                          ],
                          _buildUploadButtons(),
                          const SizedBox(height: 20),
                          if (_analysisResult != null)
                            _buildAnalysisResultSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Lottie.asset(
                  'lib/assets/animations/running_man.json',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // New method to build instruction section
  Widget _buildInstructionSection() {
    return _imageFile == null 
      ? Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: primaryColor,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'How to Use Food Analyzer',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'To know about your food, simply click "Take Photo" or "Upload Image" below. Then, select the type of analysis you want:\n\n'
                '• Detect Allergens\n'
                '• Get Detailed Nutrient Info\n'
                '• Learn About Food\n'
                '• Discover Fun Facts\n'
                '• Generate Dish Recipes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      : const SizedBox.shrink();
  }

  Widget _buildImageContainer() {
    return Hero(
      tag: 'food-image',
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            _imageFile!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildUploadButton(
          "Take Photo",
          Icons.camera_alt,
          primaryColor,
          () => _pickImage(ImageSource.camera),
        ),
        const SizedBox(width: 20),
        _buildUploadButton(
          "Upload Image",
          Icons.photo_library,
          accentColor,
          () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildUploadButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResultSection() {
    // Check if there's an error
    if (_analysisResult is Map && _analysisResult.containsKey('error')) {
      return _buildErrorSection(_analysisResult['error']);
    }

    // Render different sections based on analysis type
    switch (_selectedAnalysisType) {
      case AnalysisType.DETAILED_NUTRIENT_INFO:
        return _buildNutrientInfoSection();
      case AnalysisType.DETECT_ALLERGENS:
        return _buildAllergenSection();
      case AnalysisType.LEARN_ABOUT_FOOD:
        return _buildFoodInfoSection();
      case AnalysisType.FUN_FACTS:
        return _buildFunFactsSection();
      case AnalysisType.GENERATE_DISH:
        return _buildDishGenerationSection();
    }
  }

  Widget _buildErrorSection(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(
            'Analysis Error',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.red.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfoSection() {
    final detectedItems = _analysisResult['detected_food_items'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Nutrient Information'),
        if (detectedItems.isNotEmpty)
          ...detectedItems.map((item) => _buildNutrientCard(item)).toList(),
        
        if (_analysisResult['total_meal_nutrition'] != null)
          _buildTotalNutritionSummary(_analysisResult['total_meal_nutrition']),
      ],
    );
  }

  Widget _buildAllergenSection() {
    final detectedItems = _analysisResult['detected_food_items'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Allergen Detection'),
        if (detectedItems.isNotEmpty)
          ...detectedItems.map((item) => _buildAllergenCard(item)).toList(),
      ],
    );
  }

  Widget _buildFoodInfoSection() {
    final detectedItems = _analysisResult['detected_food_items'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Food Information'),
        if (detectedItems.isNotEmpty)
          ...detectedItems.map((item) => _buildFoodInfoCard(item)).toList(),
      ],
    );
  }

  Widget _buildFunFactsSection() {
    final detectedItems = _analysisResult['detected_food_items'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Fun Food Facts'),
        if (detectedItems.isNotEmpty)
          ...detectedItems.map((item) => _buildFunFactCard(item)).toList(),
      ],
    );
  }

  Widget _buildDishGenerationSection() {
    final suggestedDishes = _analysisResult['suggested_dishes'] ?? [];
    final detectedIngredients = _analysisResult['detected_ingredients'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Dish Generation'),
        _buildDetectedIngredientsChip(detectedIngredients),
        const SizedBox(height: 10),
        if (suggestedDishes.isNotEmpty)
          ...suggestedDishes.map((dish) => _buildDishCard(dish)).toList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildNutrientCard(dynamic item) {
    final nutritionInfo = item['nutritional_info'] ?? {};
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['food_item'] ?? 'Unknown Food',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildNutrientRow('Calories', nutritionInfo['calories_kcal']),
            _buildNutrientRow('Protein', nutritionInfo['protein_g']),
            _buildNutrientRow('Carbohydrates', nutritionInfo['carbohydrates_g']),
            _buildNutrientRow('Fat', nutritionInfo['fat_g']),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(),
          ),
          Text(
            '$value',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalNutritionSummary(dynamic totalNutrition) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Meal Nutrition',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildNutrientRow('Total Calories', totalNutrition['calories_kcal']),
            _buildNutrientRow('Total Protein', totalNutrition['protein_g']),
            _buildNutrientRow('Total Carbohydrates', totalNutrition['carbohydrates_g']),
            _buildNutrientRow('Total Fat', totalNutrition['fat_g']),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergenCard(dynamic item) {
    final allergens = item['potential_allergens'] ?? [];
    final severityMap = item['allergen_severity'] ?? {};
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['food_item'] ?? 'Unknown Food',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            ...allergens.map((allergen) => _buildAllergenRow(
              allergen, 
              severityMap[allergen] ?? 'unknown'
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergenRow(String allergen, String severity) {
    Color severityColor = severity == 'high' 
        ? Colors.red 
        : severity == 'medium' 
          ? Colors.orange 
          : Colors.green;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            allergen,
            style: GoogleFonts.poppins(),
          ),
          Text(
            severity.toUpperCase(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: severityColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodInfoCard(dynamic item) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['food_item'] ?? 'Unknown Food',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Origin', item['origin']),
            _buildInfoRow('Cultural Significance', item['cultural_significance']),
            _buildInfoRow('History', item['history']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? 'Not available',
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactCard(dynamic item) {
    final funFacts = item['fun_facts'] ?? [];
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['food_item'] ?? 'Unknown Food',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            ...funFacts.map((fact) => _buildFunFactRow(fact)).toList(),
            if (item['did_you_know'] != null) ...[
              const SizedBox(height: 10),
              Text(
                'Did You Know?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              Text(
                item['did_you_know'],
                style: GoogleFonts.poppins(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFunFactRow(String fact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fact,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedIngredientsChip(List<dynamic> ingredients) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ingredients.map((ingredient) {
        return Chip(
          label: Text(
            ingredient,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: primaryColor.withOpacity(0.2),
        );
      }).toList(),
    );
  }

  Widget _buildDishCard(dynamic dish) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dish['dish_name'] ?? 'Unknown Dish',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Cuisine', dish['cuisine_type']),
            _buildInfoRow('Difficulty', dish['difficulty_level']),
            _buildInfoRow('Preparation Time', '${dish['preparation_time_minutes']} minutes'),
            
            const SizedBox(height: 10),
            Text(
              'Ingredients',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            _buildIngredientsList(dish['ingredients']),
            
            const SizedBox(height: 10),
            Text(
              'Recipe Steps',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            ...dish['recipe_steps'].map<Widget>((step) => _buildRecipeStep(step)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList(dynamic ingredients) {
    final fromImage = ingredients['from_image'] ?? [];
    final additional = ingredients['additional_needed'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Image: ${fromImage.join(", ")}',
          style: GoogleFonts.poppins(),
        ),
        Text(
          'Additional Needed: ${additional.join(", ")}',
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildRecipeStep(String step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              step,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}