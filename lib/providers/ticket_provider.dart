import 'package:flutter/foundation.dart';
import 'package:event_ticketing_system1/models/ticket.dart';
import 'package:event_ticketing_system1/providers/event_provider.dart';

class TicketProvider extends ChangeNotifier {
  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Ticket> get tickets => [..._tickets];
  List<Ticket> get activeTickets =>
      _tickets.where((ticket) => ticket.status == 'Active').toList();
  List<Ticket> get cancelledTickets =>
      _tickets.where((ticket) => ticket.status == 'Cancelled').toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user tickets
  Future<void> fetchUserTickets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await http.get(
      //   Uri.parse('your-api-url/tickets'),
      //   headers: {'Authorization': 'Bearer $userToken'},
      // );
      // final data = json.decode(response.body);
      // _tickets = data.map((ticketData) => Ticket.fromJson(ticketData)).toList();

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

  // Book a new ticket
  Future<bool> bookTicket({
    required String eventId,
    required String eventTitle,
    required String ticketType,
    required double price,
    required EventProvider eventProvider,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Generate ticket ID (will be replaced by backend response)
      final ticketId = DateTime.now().millisecondsSinceEpoch.toString();

      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/tickets'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: json.encode({
      //     'eventId': eventId,
      //     'ticketType': ticketType,
      //     'price': price,
      //   }),
      // );
      // final ticketData = json.decode(response.body);
      // final newTicket = Ticket.fromJson(ticketData);

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Create new ticket
      final newTicket = Ticket(
        id: ticketId,
        eventId: eventId,
        eventTitle: eventTitle,
        ticketType: ticketType,
        price: price,
        purchaseDate: DateTime.now(),
        status: 'Active',
      );

      _tickets.add(newTicket);

      // Update event seats
      eventProvider.updateEventSeats(eventId, ticketType, 1);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cancel a ticket
  Future<bool> cancelTicket(
    String ticketId,
    EventProvider eventProvider,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Find the ticket
      final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
      if (ticketIndex == -1) {
        throw Exception('Ticket not found');
      }

      final ticket = _tickets[ticketIndex];

      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('your-api-url/tickets/$ticketId/cancel'),
      //   headers: {
      //     'Authorization': 'Bearer $userToken',
      //   },
      // );

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Update ticket status
      _tickets[ticketIndex] = Ticket(
        id: ticket.id,
        eventId: ticket.eventId,
        eventTitle: ticket.eventTitle,
        ticketType: ticket.ticketType,
        price: ticket.price,
        purchaseDate: ticket.purchaseDate,
        status: 'Cancelled',
      );

      // Restore event seats
      eventProvider.restoreEventSeats(ticket.eventId, ticket.ticketType, 1);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get tickets for a specific event
  List<Ticket> getTicketsForEvent(String eventId) {
    return _tickets.where((ticket) => ticket.eventId == eventId).toList();
  }

  // Get ticket by ID
  Ticket? getTicketById(String ticketId) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == ticketId);
    } catch (e) {
      return null;
    }
  }

  // Can cancel ticket (business logic)
  bool canCancelTicket(String ticketId, DateTime eventDate) {
    final ticket = getTicketById(ticketId);
    if (ticket == null || ticket.status != 'Active') return false;

    // Allow cancellation if event is more than 24 hours away
    final hoursUntilEvent = eventDate.difference(DateTime.now()).inHours;
    return hoursUntilEvent > 24;
  }

  // Get ticket statistics for an event
  Map<String, int> getTicketStatsForEvent(String eventId) {
    final eventTickets = getTicketsForEvent(eventId);

    int generalSold = 0;
    int vipSold = 0;
    int generalCancelled = 0;
    int vipCancelled = 0;

    for (final ticket in eventTickets) {
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

    return {
      'generalSold': generalSold,
      'vipSold': vipSold,
      'generalCancelled': generalCancelled,
      'vipCancelled': vipCancelled,
      'totalSold': generalSold + vipSold,
      'totalCancelled': generalCancelled + vipCancelled,
    };
  }

  // Clear all tickets (for logout)
  void clearTickets() {
    _tickets = [];
    _error = null;
    notifyListeners();
  }
}
