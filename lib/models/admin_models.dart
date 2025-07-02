class Event {
  int id;
  String name;
  DateTime date;
  String venue;
  int capacity;
  int ticketsSold;
  double price;
  String status;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.venue,
    required this.capacity,
    required this.ticketsSold,
    required this.price,
    required this.status,
  });
}

class User {
  int id;
  String name;
  String email;
  String phone;
  int totalPurchases;
  double totalSpent;
  DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.totalPurchases,
    required this.totalSpent,
    required this.joinDate,
  });
}

class Ticket {
  int id;
  int eventId;
  String eventName;
  String customerName;
  String customerEmail;
  int quantity;
  double totalPrice;
  DateTime purchaseDate;
  String status;

  Ticket({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.customerName,
    required this.customerEmail,
    required this.quantity,
    required this.totalPrice,
    required this.purchaseDate,
    required this.status,
  });
}
