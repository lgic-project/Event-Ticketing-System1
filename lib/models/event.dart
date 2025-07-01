class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final double vipPrice;
  final double generalPrice;
  final int vipSeats;
  final int generalSeats;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.vipPrice,
    required this.generalPrice,
    required this.vipSeats,
    required this.generalSeats,
  });
}
