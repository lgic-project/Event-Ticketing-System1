import 'package:flutter/foundation.dart';
import 'package:event_ticketing_system1/models/event.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Event> get events => [..._events];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with dummy data for now
  EventProvider() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _events = [
      Event(
        id: '1',
        title: 'Music Festival 2025',
        description:
            'The biggest music festival featuring top artists from around the world.',
        date: DateTime(2025, 8, 15),
        location: 'Central Park, New York',
        venue: 'Central Park Amphitheater',
        imageUrl:
            'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg',
        vipPrice: 299.99,
        generalPrice: 99.99,
        vipSeats: 500,
        generalSeats: 5000,
      ),
      Event(
        id: '2',
        title: 'Tech Conference 2025',
        description:
            'Learn about the latest technology trends and innovations.',
        date: DateTime(2025, 9, 10),
        location: 'Convention Center, San Francisco',
        venue: 'San Francisco Convention Center',
        imageUrl:
            'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg',
        vipPrice: 599.99,
        generalPrice: 199.99,
        vipSeats: 200,
        generalSeats: 2000,
      ),
      Event(
        id: '3',
        title: 'Food & Wine Expo',
        description:
            'Taste the finest cuisines and wines from around the globe.',
        date: DateTime(2025, 7, 25),
        location: 'Exhibition Hall, Chicago',
        venue: 'Chicago Exhibition Hall',
        imageUrl:
            'https://images.pexels.com/photos/5962036/pexels-photo-5962036.jpeg',
        vipPrice: 199.99,
        generalPrice: 79.99,
        vipSeats: 300,
        generalSeats: 1500,
      ),
    ];
  }

  // Fetch all events
  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await NetworkService().get(
      //   '/events',
      //   requireAuth: false,
      // );
      //
      // final List<Event> events = (response['data'] as List)
      //     .map((json) => Event.fromJson(json))
      //     .toList();
      //
      // _events = events;

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get event by ID
  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update event (for admin)
  void updateEvent(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }

  // Add event (for admin)
  void addEvent(Event newEvent) {
    _events.add(newEvent);
    notifyListeners();
  }

  // Delete event (for admin)
  void deleteEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  // Update event seats when tickets are sold
  void updateEventSeats(String eventId, String ticketType, int quantity) {
    final eventIndex = _events.indexWhere((event) => event.id == eventId);
    if (eventIndex != -1) {
      final event = _events[eventIndex];
      Event updatedEvent;

      if (ticketType.toLowerCase() == 'general') {
        updatedEvent = event.copyWith(
          generalSeats: event.generalSeats - quantity,
          ticketsSold: event.ticketsSold + quantity,
        );
      } else if (ticketType.toLowerCase() == 'vip') {
        updatedEvent = event.copyWith(
          vipSeats: event.vipSeats - quantity,
          ticketsSold: event.ticketsSold + quantity,
        );
      } else {
        return; // Invalid ticket type
      }

      _events[eventIndex] = updatedEvent;
      notifyListeners();
    }
  }

  // Restore event seats when tickets are cancelled
  void restoreEventSeats(String eventId, String ticketType, int quantity) {
    final eventIndex = _events.indexWhere((event) => event.id == eventId);
    if (eventIndex != -1) {
      final event = _events[eventIndex];
      Event updatedEvent;

      if (ticketType.toLowerCase() == 'general') {
        updatedEvent = event.copyWith(
          generalSeats: event.generalSeats + quantity,
          ticketsSold: event.ticketsSold - quantity,
        );
      } else if (ticketType.toLowerCase() == 'vip') {
        updatedEvent = event.copyWith(
          vipSeats: event.vipSeats + quantity,
          ticketsSold: event.ticketsSold - quantity,
        );
      } else {
        return; // Invalid ticket type
      }

      _events[eventIndex] = updatedEvent;
      notifyListeners();
    }
  }

  // Search events
  List<Event> searchEvents(String query) {
    if (query.isEmpty) return events;

    final lowercaseQuery = query.toLowerCase();
    return _events.where((event) {
      return event.title.toLowerCase().contains(lowercaseQuery) ||
          event.description.toLowerCase().contains(lowercaseQuery) ||
          event.location.toLowerCase().contains(lowercaseQuery) ||
          event.venue.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get upcoming events
  List<Event> get upcomingEvents {
    final now = DateTime.now();
    return _events.where((event) => event.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get past events
  List<Event> get pastEvents {
    final now = DateTime.now();
    return _events.where((event) => event.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get events by status
  List<Event> getEventsByStatus(String status) {
    return _events.where((event) => event.status == status).toList();
  }

  // Get available events (not sold out and not past)
  List<Event> get availableEvents {
    return _events
        .where((event) => !event.isSoldOut && event.isUpcoming)
        .toList();
  }

  // Calculate total revenue for all events
  double get totalRevenue {
    return _events.fold(0.0, (sum, event) {
      // Calculate based on tickets sold and average price
      final avgPrice = (event.generalPrice + event.vipPrice) / 2;
      return sum + (event.ticketsSold * avgPrice);
    });
  }

  // Get event statistics
  Map<String, dynamic> getEventStatistics(String eventId) {
    final event = getEventById(eventId);
    if (event == null) return {};

    return {
      'totalCapacity': event.totalCapacity,
      'ticketsSold': event.ticketsSold,
      'availableSeats': event.totalAvailable,
      'occupancyRate': event.totalCapacity > 0
          ? (event.ticketsSold / event.totalCapacity * 100).toStringAsFixed(1)
          : '0',
      'estimatedRevenue':
          event.ticketsSold * ((event.generalPrice + event.vipPrice) / 2),
      'status': event.displayStatus,
      'daysUntilEvent': event.date.difference(DateTime.now()).inDays,
    };
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh events
  Future<void> refreshEvents() async {
    await fetchEvents();
  }
}
