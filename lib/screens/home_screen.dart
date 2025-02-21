import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:athlete/screens/coaches_tab.dart';
import 'package:athlete/screens/leaderboard_screen.dart';
import 'package:athlete/screens/map_screen.dart';
import 'package:athlete/screens/profile_screen.dart';

// Create a separate widget for home content
class HomeContent extends StatelessWidget {
  final File? imageFile;
  const HomeContent({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imageFile != null
          ? Image.file(imageFile!) // Show the captured image
          : const Text('Tap the camera button to take a picture'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  File? _imageFile;

  // Screens list
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(imageFile: _imageFile),
      const MapScreen(),
      const CoachesTab(),
      const LeaderboardScreen(),
      const ProfileScreen(),
    ];
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Function to capture an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _screens[0] = HomeContent(imageFile: _imageFile); // Update home content with new image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Run'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record_outlined),
            activeIcon: Icon(Icons.fiber_manual_record),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
