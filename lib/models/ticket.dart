class Ticket {
  final String id;
  final String eventId;
  final String eventTitle;
  final String ticketType;
  final double price;
  final DateTime purchaseDate;
  final String status;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final int quantity;
  final double totalPrice;
  final String? qrCode;
  final String? userId;
  final DateTime? usedAt;
  final DateTime? cancelledAt;

  Ticket({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.ticketType,
    required this.price,
    required this.purchaseDate,
    required this.status,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.quantity = 1,
    double? totalPrice,
    this.qrCode,
    this.userId,
    this.usedAt,
    this.cancelledAt,
  }) : totalPrice = totalPrice ?? (price * quantity);

  // Check if ticket is active
  bool get isActive => status.toLowerCase() == 'active';

  // Check if ticket is cancelled
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  // Check if ticket is used
  bool get isUsed => status.toLowerCase() == 'used' || usedAt != null;

  // Get display status
  String get displayStatus {
    if (isUsed) return 'Used';
    if (isCancelled) return 'Cancelled';
    if (isActive) return 'Active';
    return status;
  }

  // Copy with method
  Ticket copyWith({
    String? id,
    String? eventId,
    String? eventTitle,
    String? ticketType,
    double? price,
    DateTime? purchaseDate,
    String? status,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    int? quantity,
    double? totalPrice,
    String? qrCode,
    String? userId,
    DateTime? usedAt,
    DateTime? cancelledAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      ticketType: ticketType ?? this.ticketType,
      price: price ?? this.price,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      qrCode: qrCode ?? this.qrCode,
      userId: userId ?? this.userId,
      usedAt: usedAt ?? this.usedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'ticketType': ticketType,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'qrCode': qrCode,
      'userId': userId,
      'usedAt': usedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      eventTitle: json['eventTitle'] ?? json['eventName'] ?? '',
      ticketType: json['ticketType'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      status: json['status'] ?? 'Active',
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      quantity: json['quantity'] ?? 1,
      totalPrice: json['totalPrice']?.toDouble(),
      qrCode: json['qrCode'],
      userId: json['userId']?.toString(),
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
    );
  }
}
