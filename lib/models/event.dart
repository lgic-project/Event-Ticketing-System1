class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String venue;
  final String imageUrl;
  final double vipPrice;
  final double generalPrice;
  int vipSeats;
  int generalSeats;
  final int capacity;
  int ticketsSold;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String eventCategory;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.venue,
    required this.imageUrl,
    required this.vipPrice,
    required this.generalPrice,
    required this.vipSeats,
    required this.generalSeats,
    int? capacity,
    this.ticketsSold = 0,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.eventCategory = 'all',
  }) : capacity = capacity ?? (vipSeats + generalSeats);

  // Calculate total capacity
  int get totalCapacity => vipSeats + generalSeats;

  // Calculate available seats
  int get totalAvailable => totalCapacity - ticketsSold;

  // Check if event is sold out
  bool get isSoldOut => totalAvailable <= 0;

  // Check if event is past
  bool get isPast => date.isBefore(DateTime.now());

  // Check if event is upcoming
  bool get isUpcoming => date.isAfter(DateTime.now());

  // Get formatted status
  String get displayStatus {
    if (isPast) return 'completed';
    if (isSoldOut) return 'sold_out';
    return status;
  }

  // Copy with method for updating
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? venue,
    String? imageUrl,
    double? vipPrice,
    double? generalPrice,
    int? vipSeats,
    int? generalSeats,
    int? capacity,
    int? ticketsSold,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      venue: venue ?? this.venue,
      imageUrl: imageUrl ?? this.imageUrl,
      vipPrice: vipPrice ?? this.vipPrice,
      generalPrice: generalPrice ?? this.generalPrice,
      vipSeats: vipSeats ?? this.vipSeats,
      generalSeats: generalSeats ?? this.generalSeats,
      capacity: capacity ?? this.capacity,
      ticketsSold: ticketsSold ?? this.ticketsSold,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'venue': venue,
      'imageUrl': imageUrl,
      'vipPrice': vipPrice,
      'generalPrice': generalPrice,
      'vipSeats': vipSeats,
      'generalSeats': generalSeats,
      'capacity': capacity,
      'ticketsSold': ticketsSold,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      location: json['location'] ?? '',
      venue: json['venue'] ?? json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      vipPrice: (json['vipPrice'] ?? 0).toDouble(),
      generalPrice: (json['generalPrice'] ?? json['price'] ?? 0).toDouble(),
      vipSeats: json['vipSeats'] ?? 0,
      generalSeats: json['generalSeats'] ?? 0,
      capacity: json['capacity'],
      ticketsSold: json['ticketsSold'] ?? 0,
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  get category => null;
}
