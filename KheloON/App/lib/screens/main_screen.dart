import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_screen.dart';
import 'food_detection_screen.dart';
import 'health_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'chatbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Offset _chatbotPosition = const Offset(300, 500); // Initial position

  final List<Widget> _screens = [
    const HomeScreen(),
    const FoodDetection(),
    const HealthScreen(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxX = constraints.maxWidth - 70; // Right bound (60px + padding)
          double maxY = constraints.maxHeight - 100; // Bottom bound (above nav bar)

          // Ensure chatbot doesn't go off-screen
          double safeX = _chatbotPosition.dx.clamp(10, maxX);
          double safeY = _chatbotPosition.dy.clamp(10, maxY);

          return Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              Positioned(
                left: safeX,
                top: safeY,
                child: Draggable(
                  feedback: _chatbotIcon(),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      double newX = details.offset.dx.clamp(10, maxX);
                      double newY = details.offset.dy.clamp(10, maxY);
                      _chatbotPosition = Offset(newX, newY);
                    });
                  },
                  child: _chatbotIcon(),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color(0xFFFF5722),
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.map, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.leaderboard, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _chatbotIcon() {
    return GestureDetector(
      onTap: () {
        _showChatbotPopup(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'lib/assets/Chatbot_len.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showChatbotPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text("AI Chatbot", textAlign: TextAlign.center),
          content: const Text("Would you like to chat with the assistant?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                );
              },
              child: const Text("Chat Now"),
            ),
          ],
        );
      },
    );
  }
}
