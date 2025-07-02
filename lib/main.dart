import 'package:event_ticketing_system1/screens/admin_panel.dart';
import 'package:event_ticketing_system1/screens/home_page.dart';
import 'package:event_ticketing_system1/screens/purchase_details_page.dart';
import 'package:event_ticketing_system1/screens/splash_screen.dart';
import 'package:event_ticketing_system1/screens/ticket_details_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EventTicketingApp());
}

class EventTicketingApp extends StatelessWidget {
  const EventTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ticketing',
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Roboto'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/ticket-details': (context) => TicketDetailsPage(),
        '/purchase-details': (context) => PurchaseDetailsPage(),
        '/home-page': (context) => AdminPanel(),
        '/admin-panel': (context) => HomePage(),
      },
    );
  }
}
