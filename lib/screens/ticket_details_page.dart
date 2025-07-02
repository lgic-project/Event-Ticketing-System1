import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticketing_system1/providers/event_provider.dart';
import 'package:event_ticketing_system1/providers/ticket_provider.dart';
import 'package:event_ticketing_system1/providers/purchase_provider.dart';
import 'package:event_ticketing_system1/models/event.dart';

class TicketDetailsPage extends StatefulWidget {
  const TicketDetailsPage({super.key});

  @override
  TicketDetailsPageState createState() => TicketDetailsPageState();
}

class TicketDetailsPageState extends State<TicketDetailsPage> {
  String selectedTicketType = 'General';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    final ticketProvider = context.watch<TicketProvider>();

    // Get ticket statistics for this event
    final ticketStats = ticketProvider.getTicketStatsForEvent(event.id);
    final generalAvailable =
        event.generalSeats - (ticketStats['generalSold'] ?? 0);
    final vipAvailable = event.vipSeats - (ticketStats['vipSold'] ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                event.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.event,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${event.date.day}/${event.date.month}/${event.date.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Select Ticket Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildTicketTypeCard(
                    'General',
                    event.generalPrice,
                    generalAvailable,
                  ),
                  SizedBox(height: 12),
                  _buildTicketTypeCard('VIP', event.vipPrice, vipAvailable),
                  SizedBox(height: 24),
                  Text(
                    'Customer Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _bookTicket(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Book Ticket - \$${selectedTicketType == 'VIP' ? event.vipPrice.toStringAsFixed(2) : event.generalPrice.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketTypeCard(String type, double price, int availableSeats) {
    bool isSelected = selectedTicketType == type;
    bool isAvailable = availableSeats > 0;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isAvailable
            ? () {
                setState(() {
                  selectedTicketType = type;
                });
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<String>(
                value: type,
                groupValue: selectedTicketType,
                onChanged: isAvailable
                    ? (value) {
                        setState(() {
                          selectedTicketType = value!;
                        });
                      }
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$type Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? null : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: isAvailable
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isAvailable
                          ? '$availableSeats seats available'
                          : 'Sold Out',
                      style: TextStyle(
                        color: isAvailable ? Colors.grey[600] : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (type == 'VIP' && isAvailable)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'VIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookTicket(Event event) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final ticketProvider = context.read<TicketProvider>();
      final purchaseProvider = context.read<PurchaseProvider>();
      final eventProvider = context.read<EventProvider>();

      final price = selectedTicketType == 'VIP'
          ? event.vipPrice
          : event.generalPrice;

      // Book the ticket
      final ticketSuccess = await ticketProvider.bookTicket(
        eventId: event.id,
        eventTitle: event.title,
        ticketType: selectedTicketType,
        price: price,
        eventProvider: eventProvider,
      );

      if (ticketSuccess) {
        // Create purchase record
        final purchaseSuccess = await purchaseProvider.createPurchase(
          ticketId: ticketProvider.tickets.last.id,
          customerName: _nameController.text,
          customerEmail: _emailController.text,
          customerPhone: _phoneController.text,
          paymentMethod: 'eSewa', // Default payment method
          amount: price,
        );

        setState(() {
          _isLoading = false;
        });

        if (purchaseSuccess) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Failed to process payment. Please try again.');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(
          ticketProvider.error ?? 'Failed to book ticket. Please try again.',
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Booking Successful!'),
          ],
        ),
        content: Text('Your ticket has been booked successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Booking Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
