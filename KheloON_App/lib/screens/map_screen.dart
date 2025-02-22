import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Fetch the current Firebase authenticated user
final FirebaseAuth _auth = FirebaseAuth.instance;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<calendar.Event> calendarEvents = [];
  bool isLoading = true;
  late final WebViewController _webViewController;
  User? firebaseUser;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _initializeWebView();
  }

  // Get the signed-in user from Firebase
  Future<void> _initializeUser() async {
    setState(() {
      firebaseUser = _auth.currentUser;
      userEmail = firebaseUser?.email;
    });

    if (firebaseUser != null) {
      await _fetchCalendarEvents();
    } else {
      print("No Firebase user found. Redirect to login if needed.");
    }
  }

  // Fetch Google Calendar events using the signed-in user
  Future<void> _fetchCalendarEvents() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
      if (googleUser == null) {
        print("Google Sign-In session expired or user not signed in.");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final headers = {
        "Authorization": "Bearer ${googleAuth.accessToken}",
        "Accept": "application/json",
      };

      final client = GoogleHttpClient(headers);
      final calendarApi = calendar.CalendarApi(client);

      final events = await calendarApi.events.list(
        'primary',
        timeMin: DateTime.now(),
        timeMax: DateTime.now().add(const Duration(days: 7)),
        orderBy: 'startTime',
        singleEvents: true,
      );

      setState(() {
        calendarEvents = events.items ?? [];
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching events: $error');
      setState(() => isLoading = false);
    }
  }

  // Initialize WebView with the signed-in user's calendar
  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://calendar.google.com/calendar/embed?src=$userEmail'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text('Google Calendar', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildCalendarSection(),
          _buildEventList(),
        ],
      ),
    );
  }

  // Show Google Calendar Events
  Widget _buildEventList() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Expanded(
      child: ListView.builder(
        itemCount: calendarEvents.length,
        itemBuilder: (context, index) => _buildEventCard(calendarEvents[index]),
      ),
    );
  }

  // Create a card for each event
  Widget _buildEventCard(calendar.Event event) {
    final start = event.start?.dateTime ?? DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(start);
    final formattedDate = DateFormat('MMM d').format(start);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.blue),
        title: Text(event.summary ?? 'Untitled Event', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$formattedDate at $formattedTime'),
      ),
    );
  }

  // Embed Google Calendar using WebView
  Widget _buildCalendarSection() {
    return SizedBox(
      height: 500,
      child: WebViewWidget(controller: _webViewController),
    );
  }
}

// Custom HTTP Client for Google API
class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _client.send(request..headers.addAll(_headers));
}
