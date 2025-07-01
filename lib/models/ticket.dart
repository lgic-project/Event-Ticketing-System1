class Ticket {
  final String id;
  final String eventId;
  final String eventTitle;
  final String ticketType;
  final double price;
  final DateTime purchaseDate;
  final String status;

  Ticket({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.ticketType,
    required this.price,
    required this.purchaseDate,
    required this.status,
  });
}
