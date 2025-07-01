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
          'https://images.pexels.com/photos/625644/pexels-photo-625644.jpeg',
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
      imageUrl: 'https://via.placeholder.com/300x200?text=Tech+Conference',
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
      imageUrl: 'https://via.placeholder.com/300x200?text=Food+Wine+Expo',
      vipPrice: 199.99,
      generalPrice: 79.99,
      vipSeats: 300,
      generalSeats: 1500,
    ),
  ];

  List<Ticket> tickets = [];
  List<Purchase> purchases = [];

  void addTicket(Ticket ticket) {
    tickets.add(ticket);
  }

  void addPurchase(Purchase purchase) {
    purchases.add(purchase);
  }

  void cancelTicket(String ticketId) {
    final ticketIndex = tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex != -1) {
      tickets[ticketIndex] = Ticket(
        id: tickets[ticketIndex].id,
        eventId: tickets[ticketIndex].eventId,
        eventTitle: tickets[ticketIndex].eventTitle,
        ticketType: tickets[ticketIndex].ticketType,
        price: tickets[ticketIndex].price,
        purchaseDate: tickets[ticketIndex].purchaseDate,
        status: 'Cancelled',
      );
    }
  }
}
