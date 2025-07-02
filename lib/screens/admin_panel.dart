import 'package:event_ticketing_system1/models/admin_models.dart';
import 'package:event_ticketing_system1/screens/home_page.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String searchQuery = '';

  List<Event> events = [
    Event(
      id: 1,
      name: 'Summer Music Festival',
      date: DateTime(2024, 8, 15),
      venue: 'Central Park Amphitheater',
      capacity: 5000,
      ticketsSold: 3200,
      price: 75.0,
      status: 'active',
    ),
    Event(
      id: 2,
      name: 'Tech Conference 2024',
      date: DateTime(2024, 9, 22),
      venue: 'Convention Center',
      capacity: 1000,
      ticketsSold: 850,
      price: 150.0,
      status: 'active',
    ),
    Event(
      id: 3,
      name: 'Comedy Night',
      date: DateTime(2024, 7, 30),
      venue: 'Downtown Theater',
      capacity: 300,
      ticketsSold: 300,
      price: 35.0,
      status: 'sold_out',
    ),
  ];

  List<User> users = [
    User(
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1-555-0123',
      totalPurchases: 5,
      totalSpent: 425.0,
      joinDate: DateTime(2024, 1, 15),
    ),
    User(
      id: 2,
      name: 'Jane Smith',
      email: 'jane@example.com',
      phone: '+1-555-0124',
      totalPurchases: 3,
      totalSpent: 180.0,
      joinDate: DateTime(2024, 2, 20),
    ),
  ];

  List<Ticket> tickets = [
    Ticket(
      id: 1,
      eventId: 1,
      eventName: 'Summer Music Festival',
      customerName: 'John Doe',
      customerEmail: 'john@example.com',
      quantity: 2,
      totalPrice: 150.0,
      purchaseDate: DateTime(2024, 6, 15),
      status: 'confirmed',
    ),
    Ticket(
      id: 2,
      eventId: 2,
      eventName: 'Tech Conference 2024',
      customerName: 'Jane Smith',
      customerEmail: 'jane@example.com',
      quantity: 1,
      totalPrice: 150.0,
      purchaseDate: DateTime(2024, 6, 20),
      status: 'confirmed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Statistics calculations
  double get totalRevenue =>
      events.fold(0, (sum, event) => sum + (event.ticketsSold * event.price));
  int get totalTicketsSold =>
      events.fold(0, (sum, event) => sum + event.ticketsSold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Event Ticketing Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.event), text: 'Events'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.local_activity), text: 'Tickets'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Dashboard
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Events',
                    events.length.toString(),
                    Icons.event,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Tickets Sold',
                    totalTicketsSold.toString(),
                    Icons.local_activity,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Revenue',
                    '\$${totalRevenue.toStringAsFixed(0)}',
                    Icons.attach_money,
                    Colors.purple,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    users.length.toString(),
                    Icons.people,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          SizedBox(height: 16),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventsTab(),
                _buildUsersTab(),
                _buildTicketsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    List<Event> filteredEvents = events.where((event) {
      return event.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          event.venue.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEventDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(event.status),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(event.venue, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${event.date.day}/${event.date.month}/${event.date.year}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capacity: ${event.capacity}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Sold: ${event.ticketsSold}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Price: \$${event.price}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showEventDialog(event: event),
                        icon: Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () => _deleteEvent(event.id),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    List<User> filteredUsers = users.where((user) {
      return user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showUserDialog(),
                icon: Icon(Icons.add),
                label: Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return _buildUserCard(user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showUserDialog(user: user),
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _deleteUser(user.id),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(user.email, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(user.phone, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purchases: ${user.totalPurchases}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Total Spent: \$${user.totalSpent}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Joined: ${user.joinDate.day}/${user.joinDate.month}/${user.joinDate.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsTab() {
    List<Ticket> filteredTickets = tickets.where((ticket) {
      return ticket.eventName.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          ticket.customerName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Tickets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredTickets.length,
            itemBuilder: (context, index) {
              final ticket = filteredTickets[index];
              return _buildTicketCard(ticket);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket #${ticket.id}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(ticket.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              ticket.eventName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              'Customer: ${ticket.customerName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              'Email: ${ticket.customerEmail}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity: ${ticket.quantity}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Total: \$${ticket.totalPrice}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Purchase Date:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${ticket.purchaseDate.day}/${ticket.purchaseDate.month}/${ticket.purchaseDate.year}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'active':
        color = Colors.green;
        break;
      case 'sold_out':
        color = Colors.red;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEventDialog({Event? event}) {
    final nameController = TextEditingController(text: event?.name ?? '');
    final venueController = TextEditingController(text: event?.venue ?? '');
    final capacityController = TextEditingController(
      text: event?.capacity.toString() ?? '',
    );
    final priceController = TextEditingController(
      text: event?.price.toString() ?? '',
    );
    DateTime selectedDate = event?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event == null ? 'Add Event' : 'Edit Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: venueController,
                decoration: InputDecoration(labelText: 'Venue'),
              ),
              TextField(
                controller: capacityController,
                decoration: InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (event == null) {
                _addEvent(
                  nameController.text,
                  selectedDate,
                  venueController.text,
                  int.parse(capacityController.text),
                  double.parse(priceController.text),
                );
              } else {
                _updateEvent(
                  event.id,
                  nameController.text,
                  selectedDate,
                  venueController.text,
                  int.parse(capacityController.text),
                  double.parse(priceController.text),
                );
              }
              Navigator.pop(context);
            },
            child: Text(event == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _showUserDialog({User? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user == null ? 'Add User' : 'Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (user == null) {
                _addUser(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
              } else {
                _updateUser(
                  user.id,
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
              }
              Navigator.pop(context);
            },
            child: Text(user == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _addEvent(
    String name,
    DateTime date,
    String venue,
    int capacity,
    double price,
  ) {
    setState(() {
      events.add(
        Event(
          id: events.length + 1,
          name: name,
          date: date,
          venue: venue,
          capacity: capacity,
          ticketsSold: 0,
          price: price,
          status: 'active',
        ),
      );
    });
  }

  void _updateEvent(
    int id,
    String name,
    DateTime date,
    String venue,
    int capacity,
    double price,
  ) {
    setState(() {
      final index = events.indexWhere((event) => event.id == id);
      if (index != -1) {
        events[index] = Event(
          id: id,
          name: name,
          date: date,
          venue: venue,
          capacity: capacity,
          ticketsSold: events[index].ticketsSold,
          price: price,
          status: events[index].status,
        );
      }
    });
  }

  void _deleteEvent(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                events.removeWhere((event) => event.id == id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addUser(String name, String email, String phone) {
    setState(() {
      users.add(
        User(
          id: users.length + 1,
          name: name,
          email: email,
          phone: phone,
          totalPurchases: 0,
          totalSpent: 0.0,
          joinDate: DateTime.now(),
        ),
      );
    });
  }

  void _updateUser(int id, String name, String email, String phone) {
    setState(() {
      final index = users.indexWhere((user) => user.id == id);
      if (index != -1) {
        users[index] = User(
          id: id,
          name: name,
          email: email,
          phone: phone,
          totalPurchases: users[index].totalPurchases,
          totalSpent: users[index].totalSpent,
          joinDate: users[index].joinDate,
        );
      }
    });
  }

  void _deleteUser(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                users.removeWhere((user) => user.id == id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
