import 'package:flutter/material.dart';

// lib/screens/coaches_tab.dart
class CoachesTab extends StatelessWidget {
  const CoachesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coaches'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    child: Image.network(
                      'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-POcS50aa1Su15BM9dKRumCqT4lof3a.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coach Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Specialization'),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Connect'),
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
}