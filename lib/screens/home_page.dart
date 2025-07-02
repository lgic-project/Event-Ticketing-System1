import 'package:event_ticketing_system1/models/data_manager.dart';
import 'package:event_ticketing_system1/models/event.dart';
import 'package:event_ticketing_system1/screens/admin_panel.dart';
import 'package:event_ticketing_system1/screens/purchase_details_page.dart';
import 'package:event_ticketing_system1/screens/ticket_details_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataManager dataManager = DataManager();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.admin_panel_settings_rounded),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                );
              },
              child: const Text(
                'Admin Panel',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Eventix', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildEventsTab(), _buildTicketsTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'My Tickets',
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          ...dataManager.events.map((event) => _buildEventCard(event)),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    // Get ticket sales data from DataManager
    final ticketSales = dataManager.getTicketSalesForEvent(event.id);
    final generalSold = ticketSales['generalSold'] ?? 0;
    final vipSold = ticketSales['vipSold'] ?? 0;
    final generalAvailable = event.generalSeats - generalSold;
    final vipAvailable = event.vipSeats - vipSold;
    final totalSold = generalSold + vipSold;
    final totalSeats = event.generalSeats + event.vipSeats;
    final totalAvailable = totalSeats - totalSold;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailsPage(),
              settings: RouteSettings(arguments: event),
            ),
          ).then((_) {
            // Refresh the page when returning from ticket details
            setState(() {});
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Icon(Icons.event, size: 80, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${event.date.day}/${event.date.month}/${event.date.year}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Ticket Availability Section
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Ticket Availability',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Overall availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Available:',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              '$totalAvailable / $totalSeats',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: totalAvailable > 0
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),

                        // General tickets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'General Available:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '$generalAvailable / ${event.generalSeats}',
                              style: TextStyle(
                                fontSize: 12,
                                color: generalAvailable > 0
                                    ? Colors.green[600]
                                    : Colors.red[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),

                        // VIP tickets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'VIP Available:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '$vipAvailable / ${event.vipSeats}',
                              style: TextStyle(
                                fontSize: 12,
                                color: vipAvailable > 0
                                    ? Colors.green[600]
                                    : Colors.red[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Sales summary
                        if (totalSold > 0) ...[
                          SizedBox(height: 8),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.blue[200],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 14,
                                color: Colors.blue[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '$totalSold tickets sold',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Sold out warning
                        if (totalAvailable == 0) ...[
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 14,
                                  color: Colors.red[700],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'SOLD OUT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From \$${event.generalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: totalAvailable > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketDetailsPage(),
                                    settings: RouteSettings(arguments: event),
                                  ),
                                ).then((_) {
                                  // Refresh the page when returning from ticket details
                                  setState(() {});
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: totalAvailable > 0
                              ? null
                              : Colors.grey,
                        ),
                        child: Text(
                          totalAvailable > 0 ? 'View Details' : 'Sold Out',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsTab() {
    if (dataManager.tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No tickets yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Book your first event ticket!',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // Refresh the tickets list
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: dataManager.tickets.length,
        itemBuilder: (context, index) {
          final ticket = dataManager.tickets[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ticket.status == 'Active'
                    ? Colors.green
                    : Colors.red,
                child: Icon(
                  ticket.status == 'Active' ? Icons.check : Icons.cancel,
                  color: Colors.white,
                ),
              ),
              title: Text(ticket.eventTitle),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ticket.ticketType} - \$${ticket.price.toStringAsFixed(2)}',
                  ),
                  if (ticket.status == 'Cancelled')
                    Text(
                      'Refund processed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ticket.status == 'Active'
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ticket.status,
                  style: TextStyle(
                    color: ticket.status == 'Active'
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchaseDetailsPage(),
                    settings: RouteSettings(arguments: ticket),
                  ),
                ).then((_) {
                  // Refresh when returning from purchase details
                  setState(() {});
                });
              },
            ),
          );
        },
      ),
    );
  }
}
