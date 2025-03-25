import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showQuote = false;
  int _quoteIndex = 0;
  late Timer _quoteTimer;

  final List<String> _motivationalQuotes = [
    'Every mile is a challenge conquered.',
    'Sweat is just fat crying.',
    'Push your limits, break your boundaries.',
    'Champions are made when no one is watching.',
    'The body achieves what the mind believes.',
  ];

  final List<String> _activityImages = [
    'lib/assets/images/squad_run1.png',
    'lib/assets/images/squad_run2.png',
    'lib/assets/images/squad_run3.png',
    'lib/assets/images/squad_run4.png',
  ];

  final List<YouTubeVideo> _recommendedVideos = [
    YouTubeVideo(
      title: 'Ultimate Running Techniques for Beginners',
      thumbnailUrl: 'https://i.ytimg.com/vi/fqRuf5ehiOA/hq720.jpg',
      channelName: 'Nick Bare',
      videoUrl: 'https://www.youtube.com/watch?v=fqRuf5ehiOA&t=74s',
    ),
    YouTubeVideo(
      title: 'Strength Training for Runners',
      thumbnailUrl: 'https://i.ytimg.com/vi/GcZJhNi2yOM/hq720.jpg',
      channelName: 'E3 Rehab',
      videoUrl: 'https://www.youtube.com/watch?v=GcZJhNi2yOM',
    ),
    YouTubeVideo(
      title: 'Nutrition Tips for Endurance Athletes',
      thumbnailUrl: 'https://i.ytimg.com/vi/TH0Jjzw2EqA/hq720.jpg',
      channelName: 'Global Triathlon Network',
      videoUrl: 'https://www.youtube.com/watch?v=TH0Jjzw2EqA',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startQuoteTimer();
  }

  void _onScroll() {
    if (_scrollController.offset > 300) {
      setState(() {
        _showQuote = true;
      });
    }
  }

  void _startQuoteTimer() {
    _quoteTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_showQuote) {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % _motivationalQuotes.length;
        });
      }
    });
  }

  Future<void> _launchVideo(String url) async {
    final Uri videoUri = Uri.parse(url);
    if (!await launchUrl(videoUri, mode: LaunchMode.externalApplication)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quoteTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Athlete Support',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black87,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Image.asset(
                'lib/assets/images/background_image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),

              // Motivational Quote Box (Fixed Size)
              if (_showQuote)
                Center(
                  child: Container(
                    width: 300,
                    height: 80,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _motivationalQuotes[_quoteIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange[800],
                        ),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 30),

              // Activity Images
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activityImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          _activityImages[index],
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              // Additional Paragraphs (Scrollable Content)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How Our App Helps Athletes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[900],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '🏃‍♂️ Our app helps athletes improve their performance with personalized training insights.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '💪 Get strength training and nutrition tips tailored to your needs.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '📊 Track your health metrics like steps, heart rate, and calories using Health Connect integration.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Recommended Videos Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Videos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[900],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendedVideos.length,
                        itemBuilder: (context, index) {
                          final video = _recommendedVideos[index];
                          return GestureDetector(
                            onTap: () => _launchVideo(video.videoUrl),
                            child: CachedNetworkImage(
                              imageUrl: video.thumbnailUrl,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }
}

class YouTubeVideo {
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String videoUrl;

  YouTubeVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.videoUrl,
  });
}
