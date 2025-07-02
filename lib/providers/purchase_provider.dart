import 'package:flutter/foundation.dart';
import 'package:event_ticketing_system1/models/purchase.dart';

class PurchaseProvider extends ChangeNotifier {
  List<Purchase> _purchases = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Purchase> get purchases => [..._purchases];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user purchases
  Future<void> fetchUserPurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await http.get(
      //   Uri.parse('your-api-url/purchases'),
      //   headers: {'Authorization': 'Bearer $userToken'},
      // );
      // final data = json.decode(response.body);
      // _purchases = data.map((purchaseData) => Purchase.fromJson(purchaseData)).toList();

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

  // Create a new purchase
  Future<bool> createPurchase({
    required String ticketId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String paymentMethod,
    required double amount,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Generate purchase ID (will be replaced by backend response)
      final purchaseId = DateTime.now().millisecondsSinceEpoch.toString();

      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('your-api-url/purchases'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: json.encode({
      //     'ticketId': ticketId,
      //     'customerName': customerName,
      //     'customerEmail': customerEmail,
      //     'customerPhone': customerPhone,
      //     'paymentMethod': paymentMethod,
      //     'amount': amount,
      //   }),
      // );
      // final purchaseData = json.decode(response.body);
      // final newPurchase = Purchase.fromJson(purchaseData);

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Create new purchase
      final newPurchase = Purchase(
        id: purchaseId,
        ticketId: ticketId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        purchaseDate: DateTime.now(),
        paymentMethod: paymentMethod,
        amount: amount,
      );

      _purchases.add(newPurchase);

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

  // Get purchase by ticket ID
  Purchase? getPurchaseByTicketId(String ticketId) {
    try {
      return _purchases.firstWhere((purchase) => purchase.ticketId == ticketId);
    } catch (e) {
      return null;
    }
  }

  // Get purchase by ID
  Purchase? getPurchaseById(String purchaseId) {
    try {
      return _purchases.firstWhere((purchase) => purchase.id == purchaseId);
    } catch (e) {
      return null;
    }
  }

  // Process refund (when ticket is cancelled)
  Future<bool> processRefund(String ticketId) async {
    try {
      final purchase = getPurchaseByTicketId(ticketId);
      if (purchase == null) {
        throw Exception('Purchase not found');
      }

      // TODO: Replace with actual API call for refund processing
      // final response = await http.post(
      //   Uri.parse('your-api-url/refunds'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $userToken',
      //   },
      //   body: json.encode({
      //     'purchaseId': purchase.id,
      //     'amount': purchase.amount,
      //   }),
      // );

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // In a real app, you might update the purchase status to 'refunded'
      // For now, we'll just return success

      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  // Get total spent by user
  double getTotalSpent() {
    return _purchases.fold(0.0, (sum, purchase) => sum + purchase.amount);
  }

  // Get purchases within date range
  List<Purchase> getPurchasesByDateRange(DateTime start, DateTime end) {
    return _purchases.where((purchase) {
      return purchase.purchaseDate.isAfter(start) &&
          purchase.purchaseDate.isBefore(end);
    }).toList();
  }

  // Clear all purchases (for logout)
  void clearPurchases() {
    _purchases = [];
    _error = null;
    notifyListeners();
  }
}
