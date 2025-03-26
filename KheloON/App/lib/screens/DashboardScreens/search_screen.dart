import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = [
    'Protein shake recipe',
    'Low carb meals',
    'Vegetarian dinner',
    'Post workout nutrition',
  ];

  final List<Map<String, dynamic>> _foodItems = [
    {
      'name': 'Grilled Chicken Breast',
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fat': 3.6,
      'image': 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Salmon Fillet',
      'calories': 206,
      'protein': 22,
      'carbs': 0,
      'fat': 13,
      'image': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Quinoa Bowl',
      'calories': 222,
      'protein': 8,
      'carbs': 39,
      'fat': 4,
      'image': 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Greek Yogurt',
      'calories': 100,
      'protein': 10,
      'carbs': 3.6,
      'fat': 0.4,
      'image': 'https://images.unsplash.com/photo-1488477181946-6428a0291777?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Avocado Toast',
      'calories': 190,
      'protein': 4,
      'carbs': 20,
      'fat': 10,
      'image': 'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
  ];

  final List<Map<String, dynamic>> _exerciseItems = [
    {
      'name': 'Running',
      'calories': '500-700 cal/hour',
      'type': 'Cardio',
      'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Strength Training',
      'calories': '300-500 cal/hour',
      'type': 'Strength',
      'image': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
    {
      'name': 'Yoga',
      'calories': '200-300 cal/hour',
      'type': 'Flexibility',
      'image': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for foods, exercises, recipes...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5722)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFFF5722)),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildInitialContent()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(search),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          _buildCategoriesGrid(),
          const SizedBox(height: 20),
          Text(
            'Trending Foods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          _buildTrendingFoods(),
          const SizedBox(height: 20),
          Text(
            'Popular Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          _buildPopularExercises(),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Breakfast', 'icon': Icons.free_breakfast},
      {'name': 'Lunch', 'icon': Icons.lunch_dining},
      {'name': 'Dinner', 'icon': Icons.dinner_dining},
      {'name': 'Snacks', 'icon': Icons.cookie},
      {'name': 'Drinks', 'icon': Icons.local_drink},
      {'name': 'Desserts', 'icon': Icons.icecream},
      {'name': 'Vegetarian', 'icon': Icons.eco},
      {'name': 'Protein', 'icon': Icons.fitness_center},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category['icon'] as IconData,
                color: const Color(0xFFFF5722),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category['name'] as String,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrendingFoods() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final food = _foodItems[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 15),
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    food['image'] as String,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${food['calories']} cal | ${food['protein']}g protein',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            size: 16,
                            color: const Color(0xFFFF5722),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Add to diary',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFFF5722),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularExercises() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _exerciseItems.length,
        itemBuilder: (context, index) {
          final exercise = _exerciseItems[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 15),
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    exercise['image'] as String,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${exercise['calories']} | ${exercise['type']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            size: 16,
                            color: const Color(0xFFFF5722),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Start workout',
                            style: TextStyle(
                              fontSize: 8,
                              color: const Color(0xFFFF5722),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    final filteredFoods = _foodItems.where((food) =>
        food['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    final filteredExercises = _exerciseItems.where((exercise) =>
        exercise['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (filteredFoods.isNotEmpty) ...[
          Text(
            'Foods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          ...filteredFoods.map((food) => _buildFoodResultItem(food)),
          const SizedBox(height: 20),
        ],
        if (filteredExercises.isNotEmpty) ...[
          Text(
            'Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          ...filteredExercises.map((exercise) => _buildExerciseResultItem(exercise)),
        ],
        if (filteredFoods.isEmpty && filteredExercises.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found for "$_searchQuery"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFoodResultItem(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              food['image'] as String,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${food['calories']} calories',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF5722),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Protein: ${food['protein']}g | Carbs: ${food['carbs']}g | Fat: ${food['fat']}g',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFFFF5722),
            ),
            onPressed: () {
              // Add to diary
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseResultItem(Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              exercise['image'] as String,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  exercise['calories'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF5722),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Type: ${exercise['type']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_circle_fill,
              color: Color(0xFFFF5722),
            ),
            onPressed: () {
              // Start workout
            },
          ),
        ],
      ),
    );
  }
}
