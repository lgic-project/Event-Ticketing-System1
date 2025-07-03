import 'package:event_ticketing_system1/providers/purchase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticketing_system1/providers/event_provider.dart';
import 'package:event_ticketing_system1/providers/ticket_provider.dart';
import 'package:event_ticketing_system1/providers/auth_provider.dart';
import 'package:event_ticketing_system1/models/event.dart';
import 'package:event_ticketing_system1/screens/admin_panel.dart';
import 'package:event_ticketing_system1/screens/purchase_details_page.dart';
import 'package:event_ticketing_system1/screens/ticket_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    Future.microtask(() {
      context.read<EventProvider>().fetchEvents();
      context.read<TicketProvider>().fetchUserTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    authProvider.currentUser?.name ?? 'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authProvider.currentUser?.email ?? 'guest@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (authProvider.isAdmin)
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin Panel'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  );
                },
              ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _handleLogout(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Eventix', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildEventsTab(), _buildTicketsTab()],
      ),
      bottomNavigationBar: _selectedIndex == 0
          ? _buildCategoryBottomNav()
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number),
                  label: 'My Tickets',
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryBottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category Filter Bar
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All', Icons.event),
                _buildCategoryChip('Music', Icons.music_note),
                _buildCategoryChip('Seminar', Icons.school),
                _buildCategoryChip('Sports', Icons.sports),
                _buildCategoryChip('Other', Icons.category),
              ],
            ),
          ),
        ),
        // Bottom Navigation Bar
        BottomNavigationBar(
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
      ],
    );
  }

  Widget _buildCategoryChip(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 4),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300]!,
        ),
      ),
    );
  }

  List<Event> _getFilteredEvents(List<Event> events) {
    if (_selectedCategory == 'All') {
      return events;
    }
    if (_selectedCategory == 'Music') {
      return events;
    }
    if (_selectedCategory == 'Sports') {
      return events;
    }
    if (_selectedCategory == 'Seminar') {
      return events;
    }

    return events.where((event) {
      // Assuming the Event model has a category field
      // If not, you might need to add logic to determine category based on title/description
      return event.category?.toLowerCase() == _selectedCategory.toLowerCase() ||
          (_selectedCategory == 'Other' &&
              (event.category != null ||
                  !['Music', 'Seminar', 'Sports'].contains(event.category)));
    }).toList();
  }

  Widget _buildEventsTab() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (eventProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${eventProvider.error}'),
                ElevatedButton(
                  onPressed: () => eventProvider.fetchEvents(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        final filteredEvents = _getFilteredEvents(eventProvider.upcomingEvents);

        return RefreshIndicator(
          onRefresh: () => eventProvider.fetchEvents(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory == 'All'
                      ? 'Upcoming Events'
                      : '$_selectedCategory Events',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                ...filteredEvents.map((event) => _buildEventCard(event)),
                if (filteredEvents.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _selectedCategory == 'All'
                                ? 'No upcoming events'
                                : 'No $_selectedCategory events',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventCard(Event event) {
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        // Get ticket statistics for this event
        final ticketStats = ticketProvider.getTicketStatsForEvent(event.id);

        final generalAvailable =
            event.generalSeats - (ticketStats['generalSold'] ?? 0);
        final vipAvailable = event.vipSeats - (ticketStats['vipSold'] ?? 0);
        final totalSold = ticketStats['totalSold'] ?? 0;
        final totalSeats = event.generalSeats + event.vipSeats;
        final totalAvailable = totalSeats - totalSold;

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetailsPage(),
                  settings: RouteSettings(arguments: event),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.event,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 16,
                            color: Colors.grey[600],
                          ),
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
                              overflow: TextOverflow.ellipsis,
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
                            // Total availability
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Available:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                            SizedBox(height: 8),
                            // Ticket type breakdown
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  // General tickets
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'General',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${event.generalPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  generalAvailable > 0
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                                  size: 14,
                                                  color: generalAvailable > 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '$generalAvailable left',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: generalAvailable > 0
                                                        ? Colors.green[700]
                                                        : Colors.red[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  // VIP tickets
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[100],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'VIP',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.orange[800],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${event.vipPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  vipAvailable > 0
                                                      ? Icons.check_circle
                                                      : Icons.cancel,
                                                  size: 14,
                                                  color: vipAvailable > 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '$vipAvailable left',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: vipAvailable > 0
                                                        ? Colors.green[700]
                                                        : Colors.red[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                            ] else if (totalAvailable < 10) ...[
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      size: 14,
                                      color: Colors.orange[700],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Limited Availability',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[700],
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
                                        builder: (context) =>
                                            TicketDetailsPage(),
                                        settings: RouteSettings(
                                          arguments: event,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: totalAvailable > 0
                                  ? Theme.of(context).colorScheme.primary
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
      },
    );
  }

  Widget _buildTicketsTab() {
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        if (ticketProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (ticketProvider.tickets.isEmpty) {
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
          onRefresh: () => ticketProvider.fetchUserTickets(),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: ticketProvider.tickets.length,
            itemBuilder: (context, index) {
              final ticket = ticketProvider.tickets[index];
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
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthProvider>().logout();
              // Clear all user data
              context.read<TicketProvider>().clearTickets();
              context.read<PurchaseProvider>().clearPurchases();
              // Navigate to login and remove all previous routes
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
