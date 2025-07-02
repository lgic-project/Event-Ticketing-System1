import 'package:event_ticketing_system1/models/event.dart';
import 'package:event_ticketing_system1/models/purchase.dart';
import 'package:event_ticketing_system1/models/ticket.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  List<Event> events = [
    Event(
      id: '1',
      title: 'Music Festival 2025',
      description:
          'The biggest music festival featuring top artists from around the world.',
      date: DateTime(2025, 8, 15),
      location: 'Central Park, New York',
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
      description: 'Learn about the latest technology trends and innovations.',
      date: DateTime(2025, 9, 10),
      location: 'Convention Center, San Francisco',
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
      description: 'Taste the finest cuisines and wines from around the globe.',
      date: DateTime(2025, 7, 25),
      location: 'Exhibition Hall, Chicago',
      imageUrl:
          'https://images.pexels.com/photos/5962036/pexels-photo-5962036.jpeg',
      vipPrice: 199.99,
      generalPrice: 79.99,
      vipSeats: 300,
      generalSeats: 1500,
    ),
  ];

  List<Ticket> tickets = [];
  List<Purchase> purchases = [];

  /// Adds a new ticket to the system
  void addTicket(Ticket ticket) {
    tickets.add(ticket);
  }

  /// Adds a new purchase record
  void addPurchase(Purchase purchase) {
    purchases.add(purchase);
  }

  /// Cancels a ticket and processes refund
  /// This increases ticket availability for the event
  void cancelTicket(String ticketId) {
    final ticketIndex = tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex != -1) {
      final oldTicket = tickets[ticketIndex];
      tickets[ticketIndex] = Ticket(
        id: oldTicket.id,
        eventId: oldTicket.eventId,
        eventTitle: oldTicket.eventTitle,
        ticketType: oldTicket.ticketType,
        price: oldTicket.price,
        purchaseDate: oldTicket.purchaseDate,
        status: 'Cancelled',
      );
    }
  }

  /// Gets ticket sales data for a specific event
  /// Returns a map with counts of sold tickets by type
  Map<String, int> getTicketSalesForEvent(String eventId) {
    int generalSold = 0;
    int vipSold = 0;
    int generalCancelled = 0;
    int vipCancelled = 0;

    for (final ticket in tickets) {
      if (ticket.eventId == eventId) {
        if (ticket.ticketType.toLowerCase() == 'general') {
          if (ticket.status == 'Active') {
            generalSold++;
          } else if (ticket.status == 'Cancelled') {
            generalCancelled++;
          }
        } else if (ticket.ticketType.toLowerCase() == 'vip') {
          if (ticket.status == 'Active') {
            vipSold++;
          } else if (ticket.status == 'Cancelled') {
            vipCancelled++;
          }
        }
      }
    }

    return {
      'generalSold': generalSold,
      'vipSold': vipSold,
      'generalCancelled': generalCancelled,
      'vipCancelled': vipCancelled,
      'totalSold': generalSold + vipSold,
      'totalCancelled': generalCancelled + vipCancelled,
    };
  }

  /// Gets available seats for a specific event and ticket type
  int getAvailableSeats(String eventId, String ticketType) {
    final event = events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final salesData = getTicketSalesForEvent(eventId);

    if (ticketType.toLowerCase() == 'general') {
      return event.generalSeats - (salesData['generalSold'] ?? 0);
    } else if (ticketType.toLowerCase() == 'vip') {
      return event.vipSeats - (salesData['vipSold'] ?? 0);
    }

    return 0;
  }

  /// Checks if tickets are available for booking
  bool areTicketsAvailable(String eventId, String ticketType, int quantity) {
    final availableSeats = getAvailableSeats(eventId, ticketType);
    return availableSeats >= quantity;
  }

  /// Gets total revenue for a specific event
  double getTotalRevenueForEvent(String eventId) {
    double totalRevenue = 0.0;

    for (final ticket in tickets) {
      if (ticket.eventId == eventId && ticket.status == 'Active') {
        totalRevenue += ticket.price;
      }
    }

    return totalRevenue;
  }

  /// Gets overall statistics for all events
  Map<String, dynamic> getOverallStatistics() {
    int totalActiveTickets = tickets.where((t) => t.status == 'Active').length;
    int totalCancelledTickets = tickets
        .where((t) => t.status == 'Cancelled')
        .length;
    double totalRevenue = 0.0;

    for (final ticket in tickets) {
      if (ticket.status == 'Active') {
        totalRevenue += ticket.price;
      }
    }

    return {
      'totalActiveTickets': totalActiveTickets,
      'totalCancelledTickets': totalCancelledTickets,
      'totalRevenue': totalRevenue,
      'totalEvents': events.length,
    };
  }

  /// Gets detailed event statistics
  Map<String, dynamic> getEventStatistics(String eventId) {
    final event = events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => throw Exception('Event not found'),
    );

    final salesData = getTicketSalesForEvent(eventId);
    final revenue = getTotalRevenueForEvent(eventId);
    final totalCapacity = event.generalSeats + event.vipSeats;
    final totalSold = salesData['totalSold'] ?? 0;
    final occupancyRate = totalCapacity > 0
        ? (totalSold / totalCapacity * 100)
        : 0.0;

    return {
      'eventTitle': event.title,
      'totalCapacity': totalCapacity,
      'generalCapacity': event.generalSeats,
      'vipCapacity': event.vipSeats,
      'generalSold': salesData['generalSold'],
      'vipSold': salesData['vipSold'],
      'generalAvailable': event.generalSeats - (salesData['generalSold'] ?? 0),
      'vipAvailable': event.vipSeats - (salesData['vipSold'] ?? 0),
      'totalSold': totalSold,
      'totalCancelled': salesData['totalCancelled'],
      'occupancyRate': occupancyRate,
      'revenue': revenue,
    };
  }

  /// Gets user's ticket history
  List<Ticket> getUserTickets() {
    return List.from(tickets);
  }

  /// Gets active tickets only
  List<Ticket> getActiveTickets() {
    return tickets.where((ticket) => ticket.status == 'Active').toList();
  }

  /// Gets cancelled tickets only
  List<Ticket> getCancelledTickets() {
    return tickets.where((ticket) => ticket.status == 'Cancelled').toList();
  }

  /// Validates if a ticket can be cancelled
  bool canCancelTicket(String ticketId) {
    final ticket = tickets.firstWhere(
      (t) => t.id == ticketId,
      orElse: () => throw Exception('Ticket not found'),
    );

    // Can only cancel active tickets
    if (ticket.status != 'Active') return false;

    // Can only cancel if event is in the future (add your business logic here)
    final event = events.firstWhere(
      (e) => e.id == ticket.eventId,
      orElse: () => throw Exception('Event not found'),
    );

    // Allow cancellation if event is more than 24 hours away
    final hoursUntilEvent = event.date.difference(DateTime.now()).inHours;
    return hoursUntilEvent > 24;
  }

  /// Gets purchase details for a specific ticket
  Purchase? getPurchaseForTicket(String ticketId) {
    try {
      return purchases.firstWhere((p) => p.ticketId == ticketId);
    } catch (e) {
      return null;
    }
  }

  /// Clears all data (useful for testing)
  void clearAllData() {
    tickets.clear();
    purchases.clear();
  }

  /// Gets events with availability status
  List<Map<String, dynamic>> getEventsWithAvailability() {
    return events.map((event) {
      final salesData = getTicketSalesForEvent(event.id);
      final totalCapacity = event.generalSeats + event.vipSeats;
      final totalAvailable = totalCapacity - (salesData['totalSold'] ?? 0);

      return {
        'event': event,
        'totalAvailable': totalAvailable,
        'totalCapacity': totalCapacity,
        'generalAvailable':
            event.generalSeats - (salesData['generalSold'] ?? 0),
        'vipAvailable': event.vipSeats - (salesData['vipSold'] ?? 0),
        'isSoldOut': totalAvailable <= 0,
        'salesData': salesData,
      };
    }).toList();
  }

  void updateEvent(Event event) {}

  void updateEventGeneralTickets(String id, param1) {}

  void updateEventVipTickets(String id, param1) {}
}
