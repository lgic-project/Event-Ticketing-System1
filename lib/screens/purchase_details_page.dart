import 'package:event_ticketing_system1/models/data_manager.dart';
import 'package:event_ticketing_system1/models/purchase.dart';
import 'package:event_ticketing_system1/models/ticket.dart';
import 'package:flutter/material.dart';

class PurchaseDetailsPage extends StatelessWidget {
  final DataManager dataManager = DataManager();

  PurchaseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Ticket ticket = ModalRoute.of(context)!.settings.arguments as Ticket;
    final purchase = dataManager.purchases.firstWhere(
      (p) => p.ticketId == ticket.id,
      orElse: () => Purchase(
        id: '',
        ticketId: '',
        customerName: 'Unknown',
        customerEmail: 'unknown@email.com',
        customerPhone: 'N/A',
        purchaseDate: DateTime.now(),
        paymentMethod: 'N/A',
        amount: 0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Details'),
        backgroundColor: Colors.blue[600],
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cancel' && ticket.status == 'Active') {
                _showCancelDialog(context, ticket);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'cancel',
                enabled: ticket.status == 'Active',
                child: Text('Cancel Ticket'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          color: Colors.blue[600],
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ticket Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ticket.status == 'Active'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket.status,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    _buildInfoRow('Event', ticket.eventTitle),
                    _buildInfoRow('Ticket Type', ticket.ticketType),
                    _buildInfoRow(
                      'Price',
                      '\$${ticket.price.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      'Purchase Date',
                      '${ticket.purchaseDate.day}/${ticket.purchaseDate.month}/${ticket.purchaseDate.year}',
                    ),
                    _buildInfoRow('Ticket ID', ticket.id),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue[600], size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Customer Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    _buildInfoRow('Name', purchase.customerName),
                    _buildInfoRow('Email', purchase.customerEmail),
                    _buildInfoRow('Phone', purchase.customerPhone),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payment, color: Colors.blue[600], size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Payment Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    _buildPaymentMethodRow(purchase.paymentMethod),
                    _buildInfoRow(
                      'Amount Paid',
                      '\Rs${purchase.amount.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow('Transaction ID', purchase.id),
                  ],
                ),
              ),
            ),
            if (ticket.status == 'Active') ...[
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showCancelDialog(context, ticket),
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(String paymentMethod) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF60BB46),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'e',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'eSewa',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF60BB46),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Ticket'),
        content: Text(
          'Are you sure you want to cancel this ticket? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              DataManager().cancelTicket(ticket.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ticket cancelled successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
