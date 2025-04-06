import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showQuote = false;
  int _quoteIndex = 0;
  late Timer _quoteTimer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _motivationalQuotes = [
    'Every mile is a challenge conquered.',
    'Sweat is just fat crying.',
    'Push your limits, break your boundaries.',
    'Champions are made when no one is watching.',
    'The body achieves what the mind believes.',
  ];

  final List<SocialMediaPost> _socialPosts = [
    SocialMediaPost(
      username: 'RunnerPro',
      userAvatar: 'https://th.bing.com/th/id/OIP.3hyI-iV8TeE7mML6MZrlBAHaHa?rs=1&pid=ImgDetMain',
      postImage: 'https://th.bing.com/th/id/OIP.Whhma2_LCKodWTAokKXowQHaEj?rs=1&pid=ImgDetMain',
      caption: 'Crushing my morning run! 5AM club checking in 💪',
      likes: 1245,
      comments: 56,
    ),
    SocialMediaPost(
      username: 'FitnessJourney',
      userAvatar: 'https://th.bing.com/th/id/OIP.3vASbQEyHPrIlfezNJ0zzgHaD4?rs=1&pid=ImgDetMain',
      postImage: 'https://th.bing.com/th/id/OIP.Y5hArfpyQXNKd0Mf8iPfKgHaE8?rs=1&pid=ImgDetMain',
      caption: 'Transformation is a journey, not a destination',
      likes: 987,
      comments: 42,
    ),
    SocialMediaPost(
      username: 'EnduranceAthlete',
      userAvatar: 'https://th.bing.com/th/id/OIP.5Pg9TMU-dgTEwsvf3gyaLgHaEK?rs=1&pid=ImgDetMain',
      postImage: 'https://th.bing.com/th/id/R.663e7226bab62462fd6b929b28637a0b?rik=km1w59WW3Mbl3A&riu=http%3a%2f%2fwww.cpcnagpur.com%2fwp-content%2fuploads%2f2013%2f12%2fLagori.jpg&ehk=%2frMVvzkyH4neVTXOsBnAi4dyQXNz2V12vKIKDuHSrPc%3d&risl=&pid=ImgRaw&r=0',
      caption: 'Trail running weekend vibes 🏃‍♀️🌄',
      likes: 1678,
      comments: 89,
    ),

    SocialMediaPost(
      username: 'AkhandBharat',
      userAvatar: 'https://th.bing.com/th/id/OIP.8pR3p_-dnJzui3G6Wf9gvwHaEd?rs=1&pid=ImgDetMain',
      postImage: 'https://th.bing.com/th/id/OIP.4xwZyYoSapDWmtSZkB61iAHaEK?rs=1&pid=ImgDetMain',
      caption: 'Once a winner Always a winner',
      likes: 168,
      comments: 69,
    ),
    SocialMediaPost(
      username: 'ProPlayer',
      userAvatar: 'https://th.bing.com/th/id/OIP.7G95UY_Tsw6ESybv5g7YiQHaD9?w=700&h=375&rs=1&pid=ImgDetMain',
      postImage: 'https://th.bing.com/th/id/OIP.PbbA0kQbnuYpe12FIsK7BAHaEZ?w=651&h=386&rs=1&pid=ImgDetMain',
      caption: 'Thanks to all who supports me',
      likes: 173,
      comments: 79,
    ),
  ];

  final List<YouTubeVideo> _recommendedVideos = [
    YouTubeVideo(
      title: 'Ultimate Running Techniques for Beginners',
      thumbnailUrl: 'https://i.ytimg.com/vi/mt6-i8kAUog/hq720.jpg',
      channelName: 'Sports and fitness tips',
      videoUrl: 'https://www.youtube.com/watch?v=mt6-i8kAUog',
    ),
    YouTubeVideo(
      title: 'Strength Training for Runners',
      thumbnailUrl: 'https://i.ytimg.com/vi/RYqwMMuz0i4/hq720.jpg',
      channelName: 'Dr Rajiv Running Diaries',
      videoUrl: 'https://www.youtube.com/watch?v=RYqwMMuz0i4',
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

    // Animation controller for quote
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.offset > 300) {
      setState(() {
        _showQuote = true;
        _animationController.forward();
      });
    }
  }

  void _startQuoteTimer() {
    _quoteTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_showQuote) {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % _motivationalQuotes.length;
          _animationController.reset();
          _animationController.forward();
        });
      }
    });
  }

  Future<void> _launchVideo(String url) async {
    final Uri videoUri = Uri.parse(url);
    if (!await launchUrl(videoUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quoteTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSocialMediaPost(SocialMediaPost post) {
    return AnimationConfiguration.staggeredList(
      position: _socialPosts.indexOf(post),
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(post.userAvatar),
                  ),
                  title: Text(
                    post.username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: post.postImage,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.caption,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 20),
                          SizedBox(width: 5),
                          Text('${post.likes} likes'),
                          SizedBox(width: 20),
                          Icon(Icons.comment, color: Colors.grey, size: 20),
                          SizedBox(width: 5),
                          Text('${post.comments} comments'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              'Hello Athletes',
              
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
                'lib/assets/home_img.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),
              if (_showQuote)
                Center(
                  child: FadeTransition(
                    opacity: _animation,
                    child: ScaleTransition(
                      scale: _animation,
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
                  ),
                ),
              SizedBox(height: 30),
              
              // Social Media Posts Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Community Feed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[900],
                  ),
                ),
              ),
              AnimationLiveList(
                children: _socialPosts.map(_buildSocialMediaPost).toList(),
              ),

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
                    Column(
                      children: _recommendedVideos.map((video) => 
                        AnimationConfiguration.staggeredList(
                          position: _recommendedVideos.indexOf(video),
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () => _launchVideo(video.videoUrl),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: video.thumbnailUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              video.title,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Text(video.channelName, style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ).toList(),
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

class SocialMediaPost {
  final String username;
  final String userAvatar;
  final String postImage;
  final String caption;
  final int likes;
  final int comments;

  SocialMediaPost({
    required this.username,
    required this.userAvatar,
    required this.postImage,
    required this.caption,
    required this.likes,
    required this.comments,
  });
}

// Mock Live List Animation
class AnimationLiveList extends StatelessWidget {
  final List<Widget> children;

  const AnimationLiveList({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}