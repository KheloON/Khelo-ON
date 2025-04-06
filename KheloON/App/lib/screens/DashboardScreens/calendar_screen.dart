import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<calendar.Event> _events = [];
  List<Appointment> _appointments = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('googleAccessToken');
      if (accessToken == null || userEmail == null) return;

      final auth.AuthClient authClient = auth.authenticatedClient(
        http.Client(),
        auth.AccessCredentials(
          auth.AccessToken("Bearer", accessToken, DateTime.now().add(Duration(hours: 1))),
          null,
          ['https://www.googleapis.com/auth/calendar.readonly'],
        ),
      );

      final calendar.CalendarApi calendarApi = calendar.CalendarApi(authClient);
      final calendar.Events personalEvents = await calendarApi.events.list('primary');

      setState(() {
        _events = personalEvents.items ?? [];
        _convertEventsToAppointments();
      });
    } catch (e) {
      debugPrint("Error fetching events: $e");
    }
  }

  void _convertEventsToAppointments() {
    _appointments = _events.map((event) {
      DateTime? startDate;
      DateTime? endDate;
      
      if (event.start?.dateTime != null) {
        startDate = event.start!.dateTime!;
      } else if (event.start?.date != null) {
        startDate = DateTime.parse(event.start!.date! as String);
      }
      
      if (event.end?.dateTime != null) {
        endDate = event.end!.dateTime!;
      } else if (event.end?.date != null) {
        endDate = DateTime.parse(event.end!.date! as String);
      }

      return Appointment(
        startTime: startDate ?? DateTime.now(),
        endTime: endDate ?? DateTime.now().add(Duration(hours: 1)),
        subject: event.summary ?? 'No Title',
        color: Colors.blue,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Calendar')),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _AppointmentDataSource(_appointments),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          showAgenda: true,
        ),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}