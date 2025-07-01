class Purchase {
  final String id;
  final String ticketId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime purchaseDate;
  final String paymentMethod;
  final double amount;

  Purchase({
    required this.id,
    required this.ticketId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.purchaseDate,
    required this.paymentMethod,
    required this.amount,
  });
}
