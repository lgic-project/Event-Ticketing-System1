import 'package:flutter/foundation.dart';
import 'package:event_ticketing_system1/models/event.dart';
import 'package:event_ticketing_system1/models/users.dart';
import 'package:event_ticketing_system1/models/ticket.dart';

class AdminProvider extends ChangeNotifier {
  List<Event> _adminEvents = [];
  List<User> _users = [];
  List<Ticket> _allTickets = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Event> get adminEvents => [..._adminEvents];
  List<User> get users => [..._users];
  List<Ticket> get allTickets => [..._allTickets];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with dummy data
  AdminProvider() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _adminEvents = [
      Event(
        id: '1',
        title: 'Summer Music Festival',
        description: 'A great summer music festival',
        date: DateTime(2024, 8, 15),
        location: 'Central Park Amphitheater',
        venue: 'Central Park Amphitheater',
        imageUrl: 'https://via.placeholder.com/150',
        vipPrice: 150.0,
        generalPrice: 75.0,
        vipSeats: 100,
        generalSeats: 900,
        ticketsSold: 3200,
        status: 'active',
      ),
      Event(
        id: '2',
        title: 'Tech Conference 2024',
        description: 'Annual tech conference',
        date: DateTime(2024, 9, 22),
        location: 'Convention Center',
        venue: 'Convention Center',
        imageUrl: 'https://via.placeholder.com/150',
        vipPrice: 300.0,
        generalPrice: 150.0,
        vipSeats: 50,
        generalSeats: 450,
        ticketsSold: 850,
        status: 'active',
      ),
      Event(
        id: '3',
        title: 'Comedy Night',
        description: 'Stand-up comedy show',
        date: DateTime(2024, 7, 30),
        location: 'Downtown Theater',
        venue: 'Downtown Theater',
        imageUrl: 'https://via.placeholder.com/150',
        vipPrice: 75.0,
        generalPrice: 35.0,
        vipSeats: 50,
        generalSeats: 250,
        ticketsSold: 300,
        status: 'sold_out',
      ),
    ];

    _users = [
      User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1-555-0123',
        totalPurchases: 5,
        totalSpent: 425.0,
        joinDate: DateTime(2024, 1, 15),
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1-555-0124',
        totalPurchases: 3,
        totalSpent: 180.0,
        joinDate: DateTime(2024, 2, 20),
      ),
    ];

    _allTickets = [
      Ticket(
        id: '1',
        eventId: '1',
        eventTitle: 'Summer Music Festival',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        ticketType: 'General',
        price: 75.0,
        quantity: 2,
        totalPrice: 150.0,
        purchaseDate: DateTime(2024, 6, 15),
        status: 'confirmed',
      ),
      Ticket(
        id: '2',
        eventId: '2',
        eventTitle: 'Tech Conference 2024',
        customerName: 'Jane Smith',
        customerEmail: 'jane@example.com',
        ticketType: 'VIP',
        price: 300.0,
        quantity: 1,
        totalPrice: 300.0,
        purchaseDate: DateTime(2024, 6, 20),
        status: 'confirmed',
      ),
    ];
  }

  // Statistics calculations
  double get totalRevenue => _adminEvents.fold(
    0,
    (sum, event) => sum + (event.ticketsSold * event.generalPrice),
  );

  int get totalTicketsSold =>
      _adminEvents.fold(0, (sum, event) => sum + event.ticketsSold);

  int get totalEvents => _adminEvents.length;

  int get totalUsers => _users.length;

  // Fetch all admin data
  Future<void> fetchAdminData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API calls
      // await Future.wait([
      //   fetchAdminEvents(),
      //   fetchUsers(),
      //   fetchAllTickets(),
      // ]);

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

  // Event Management
  Future<bool> addEvent({
    required String name,
    required DateTime date,
    required String venue,
    required int capacity,
    required double price,
    String? description,
    String? imageUrl,
    int? vipSeats,
    int? generalSeats,
    double? vipPrice,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/admin/events'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $adminToken',
      //   },
      //   body: json.encode({
      //     'name': name,
      //     'date': date.toIso8601String(),
      //     'venue': venue,
      //     'capacity': capacity,
      //     'price': price,
      //   }),
      // );

      final newEvent = Event(
        id: (_adminEvents.length + 1).toString(),
        title: name,
        description: description ?? 'Event description',
        date: date,
        location: venue,
        venue: venue,
        imageUrl: imageUrl ?? 'https://via.placeholder.com/150',
        vipPrice: vipPrice ?? price * 2,
        generalPrice: price,
        vipSeats: vipSeats ?? (capacity ~/ 5), // 20% VIP seats by default
        generalSeats:
            generalSeats ?? (capacity - (vipSeats ?? (capacity ~/ 5))),
        ticketsSold: 0,
        status: 'active',
      );

      _adminEvents.add(newEvent);
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEvent({
    required String id,
    required String name,
    required DateTime date,
    required String venue,
    required int capacity,
    required double price,
    String? description,
    String? imageUrl,
    int? vipSeats,
    int? generalSeats,
    double? vipPrice,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('your-api-url/admin/events/$id'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $adminToken',
      //   },
      //   body: json.encode({
      //     'name': name,
      //     'date': date.toIso8601String(),
      //     'venue': venue,
      //     'capacity': capacity,
      //     'price': price,
      //   }),
      // );

      final index = _adminEvents.indexWhere((event) => event.id == id);
      if (index != -1) {
        final event = _adminEvents[index];
        _adminEvents[index] = Event(
          id: id,
          title: name,
          description: description ?? event.description,
          date: date,
          location: venue,
          venue: venue,
          imageUrl: imageUrl ?? event.imageUrl,
          vipPrice: vipPrice ?? event.vipPrice,
          generalPrice: price,
          vipSeats: vipSeats ?? event.vipSeats,
          generalSeats: generalSeats ?? event.generalSeats,
          ticketsSold: event.ticketsSold,
          status: event.status,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.delete(
      //   Uri.parse('your-api-url/admin/events/$id'),
      //   headers: {'Authorization': 'Bearer $adminToken'},
      // );

      _adminEvents.removeWhere((event) => event.id == id);
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  // User Management
  Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      // TODO: Replace with actual API call

      final newUser = User(
        id: (_users.length + 1).toString(),
        name: name,
        email: email,
        phone: phone,
        totalPurchases: 0,
        totalSpent: 0.0,
        joinDate: DateTime.now(),
      );

      _users.add(newUser);
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      // TODO: Replace with actual API call

      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        final user = _users[index];
        _users[index] = User(
          id: id,
          name: name,
          email: email,
          phone: phone,
          totalPurchases: user.totalPurchases,
          totalSpent: user.totalSpent,
          joinDate: user.joinDate,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      // TODO: Replace with actual API call

      _users.removeWhere((user) => user.id == id);
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  // Search functionality
  List<Event> searchEvents(String query) {
    if (query.isEmpty) return adminEvents;

    return _adminEvents.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
          event.venue.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return users;

    return _users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Ticket> searchTickets(String query) {
    if (query.isEmpty) return allTickets;

    return _allTickets.where((ticket) {
      return ticket.eventTitle.toLowerCase().contains(query.toLowerCase()) ||
          (ticket.customerName?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  // Get statistics for a specific event
  Map<String, dynamic> getEventStatistics(String eventId) {
    final event = _adminEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final eventTickets = _allTickets
        .where((t) => t.eventId == eventId)
        .toList();
    final revenue = eventTickets.fold(
      0.0,
      (sum, ticket) => sum + ticket.totalPrice,
    );

    return {
      'event': event,
      'ticketsSold': event.ticketsSold,
      'revenue': revenue,
      'occupancyRate': (event.ticketsSold / event.capacity * 100),
    };
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
