import 'package:event_ticketing_system1/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticketing_system1/providers/ticket_provider.dart';
import 'package:event_ticketing_system1/providers/purchase_provider.dart';
import 'package:event_ticketing_system1/providers/event_provider.dart';
import 'package:event_ticketing_system1/models/ticket.dart';

class PurchaseDetailsPage extends StatelessWidget {
  const PurchaseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Ticket ticket = ModalRoute.of(context)!.settings.arguments as Ticket;
    final purchaseProvider = context.watch<PurchaseProvider>();
    final eventProvider = context.watch<EventProvider>();

    final purchase = purchaseProvider.getPurchaseByTicketId(ticket.id);
    final event = eventProvider.getEventById(ticket.eventId);

    if (purchase == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Purchase Details'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('Purchase details not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (ticket.status == 'Active' && event != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'cancel') {
                  _showCancelDialog(context, ticket, event);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'cancel',
                  enabled: context.read<TicketProvider>().canCancelTicket(
                    ticket.id,
                    event.date,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cancel Ticket'),
                    ],
                  ),
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
            // Ticket Information Card
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
                          color: Theme.of(context).colorScheme.primary,
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

            // Customer Information Card
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
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
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

            // Payment Information Card
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
                          Icons.payment,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
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
                      '\$${purchase.amount.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow('Transaction ID', purchase.id),
                    _buildInfoRow(
                      'Payment Date',
                      '${purchase.purchaseDate.day}/${purchase.purchaseDate.month}/${purchase.purchaseDate.year}',
                    ),
                  ],
                ),
              ),
            ),

            // QR Code Card (for active tickets)
            if (ticket.status == 'Active') ...[
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Show this QR code at the venue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_2,
                                size: 100,
                                color: Colors.grey[600],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'QR Code',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ticket ID: ${ticket.id}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Cancel Button (for active tickets)
            if (ticket.status == 'Active' && event != null) ...[
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      context.read<TicketProvider>().canCancelTicket(
                        ticket.id,
                        event.date,
                      )
                      ? () => _showCancelDialog(context, ticket, event)
                      : null,
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
              if (!context.read<TicketProvider>().canCancelTicket(
                ticket.id,
                event.date,
              ))
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Tickets can only be cancelled 24 hours before the event',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],

            // Refund Information (for cancelled tickets)
            if (ticket.status == 'Cancelled') ...[
              SizedBox(height: 16),
              Card(
                elevation: 4,
                color: Colors.red[50],
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
                          Icon(Icons.info, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Ticket Cancelled',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This ticket has been cancelled. The refund will be processed within 5-7 business days.',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ],
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
                  paymentMethod,
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

  void _showCancelDialog(BuildContext context, Ticket ticket, Event event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this ticket?'),
            SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange[700], size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Refund will be processed within 5-7 business days',
                      style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('No, Keep Ticket'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );

              final ticketProvider = context.read<TicketProvider>();
              final eventProvider = context.read<EventProvider>();
              final purchaseProvider = context.read<PurchaseProvider>();

              // Cancel the ticket
              final success = await ticketProvider.cancelTicket(
                ticket.id,
                eventProvider,
              );

              if (success) {
                // Process refund
                await purchaseProvider.processRefund(ticket.id);
              }

              // Hide loading dialog
              Navigator.of(context).pop();

              if (success) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Ticket cancelled successfully'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                // Go back to previous screen
                Navigator.of(context).pop();
              } else {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        SizedBox(width: 8),
                        Text(ticketProvider.error ?? 'Failed to cancel ticket'),
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
