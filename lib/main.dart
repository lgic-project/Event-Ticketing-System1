import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticketing_system1/providers/auth_provider.dart';
import 'package:event_ticketing_system1/providers/event_provider.dart';
import 'package:event_ticketing_system1/providers/ticket_provider.dart';
import 'package:event_ticketing_system1/providers/purchase_provider.dart';
import 'package:event_ticketing_system1/providers/admin_provider.dart';
import 'package:event_ticketing_system1/screens/splash_screen.dart';
import 'package:event_ticketing_system1/screens/onboarding_screen.dart';
import 'package:event_ticketing_system1/screens/login_screen.dart';
import 'package:event_ticketing_system1/screens/sign_up.dart';
import 'package:event_ticketing_system1/screens/home_page.dart';
import 'package:event_ticketing_system1/screens/admin_panel.dart';
import 'package:event_ticketing_system1/screens/ticket_details_page.dart';
import 'package:event_ticketing_system1/screens/purchase_details_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: EventTicketingApp(),
    ),
  );
}

class EventTicketingApp extends StatelessWidget {
  const EventTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ticketing',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        // Using Material 3 design
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        '/ticket-details': (context) => TicketDetailsPage(),
        '/purchase-details': (context) => PurchaseDetailsPage(),
        '/admin-panel': (context) => AdminPanel(),
      },
    );
  }
}
