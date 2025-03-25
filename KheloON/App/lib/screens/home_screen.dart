import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showQuote = false;

  final List<String> _activityImages = [
  'lib/assets/images/squad_run1.jpg',
  'lib/assets/images/squad_run2.jpg',
  'lib/assets/images/squad_run3.jpg',
  'lib/assets/images/squad_run4.jpg',
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

  final List<String> _motivationalQuotes = [
    'Every mile is a challenge conquered.',
    'Sweat is just fat crying.',
    'Push your limits, break your boundaries.',
    'Champions are made when no one is watching.'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 300) {
      setState(() {
        _showQuote = true;
      });
    }
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
              title: Text('Squad Activities', 
                style: TextStyle(
                  color: Colors.white, 
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black87,
                      offset: Offset(2.0, 2.0)
                    )
                  ]
                )
              ),
              background: Image.network(
                'https://example.com/sports_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Activity Gallery
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
                        child: CachedNetworkImage(
                          width: 200,
                          fit: BoxFit.cover,
                          imageUrl: _activityImages[index],
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Animated Motivational Quote
              if (_showQuote)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _motivationalQuotes[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[800],
                      ),
                    ).animate(
                      effects: [
                        FadeEffect(duration: 500.ms),
                        SlideEffect(begin: Offset(0, 0.2), end: Offset.zero)
                      ]
                    ),
                  ),
                ),

              // Recommended YouTube Videos Section
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
                            child: Container(
                              width: 250,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    child: CachedNetworkImage(
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: video.thumbnailUrl,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(color: Colors.white),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          video.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          video.channelName,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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