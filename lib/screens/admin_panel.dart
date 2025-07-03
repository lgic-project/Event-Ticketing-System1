import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ticketing_system1/providers/admin_provider.dart';
import 'package:event_ticketing_system1/providers/auth_provider.dart';
import 'package:event_ticketing_system1/models/event.dart';
import 'package:event_ticketing_system1/models/users.dart';
import 'package:event_ticketing_system1/models/ticket.dart';
import 'package:event_ticketing_system1/screens/home_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch admin data
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<AdminProvider>().fetchAdminData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Check if user is admin
    if (!authProvider.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'You do not have admin privileges',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (adminProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 1,
          tabs: [
            Tab(icon: Icon(Icons.event), text: 'Events'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.local_activity), text: 'Tickets'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Dashboard - Made scrollable
          Container(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(16),
              children: [
                _buildStatCard(
                  'Total Events',
                  adminProvider.totalEvents.toString(),
                  Icons.event,
                  Colors.blue,
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Tickets Sold',
                  adminProvider.totalTicketsSold.toString(),
                  Icons.local_activity,
                  Colors.green,
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Revenue',
                  '\$${adminProvider.totalRevenue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.purple,
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Total Users',
                  adminProvider.totalUsers.toString(),
                  Icons.people,
                  Colors.orange,
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
      width: 160,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    final adminProvider = context.watch<AdminProvider>();
    final filteredEvents = adminProvider.searchEvents(searchQuery);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events (${filteredEvents.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEventDialog(),
                icon: Icon(Icons.add, size: 20),
                label: Text('Add Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
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
                      event.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildStatusChip(event.displayStatus),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.venue,
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
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
                  Expanded(
                    child: Column(
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
                          'Price: \$${event.generalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showEventDialog(event: event),
                        icon: Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Edit Event',
                      ),
                      IconButton(
                        onPressed: () => _deleteEvent(event.id),
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Event',
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
    final adminProvider = context.watch<AdminProvider>();
    final filteredUsers = adminProvider.searchUsers(searchQuery);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users (${filteredUsers.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showUserDialog(),
                icon: Icon(Icons.add, size: 20),
                label: Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (user.isAdmin)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ADMIN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showUserDialog(user: user),
                      icon: Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit User',
                    ),
                    IconButton(
                      onPressed: () => _deleteUser(user.id),
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete User',
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
                Expanded(
                  child: Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  user.phone ?? 'N/A',
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
                      'Purchases: ${user.totalPurchases}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Total Spent: \$${user.totalSpent.toStringAsFixed(2)}',
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
    final adminProvider = context.watch<AdminProvider>();
    final filteredTickets = adminProvider.searchTickets(searchQuery);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Tickets (${filteredTickets.length})',
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
                Expanded(
                  child: Text(
                    'Ticket #${ticket.id}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8),
                _buildStatusChip(ticket.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              ticket.eventTitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            if (ticket.customerName != null)
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Customer: ${ticket.customerName}',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            if (ticket.customerEmail != null)
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${ticket.customerEmail}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ticket.ticketType == 'VIP'
                                ? Colors.orange[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ticket.ticketType,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ticket.ticketType == 'VIP'
                                  ? Colors.orange[800]
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Qty: ${ticket.quantity}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total: \$${ticket.totalPrice.toStringAsFixed(2)}',
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
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
    String displayText;

    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        displayText = 'ACTIVE';
        break;
      case 'sold_out':
        color = Colors.red;
        displayText = 'SOLD OUT';
        break;
      case 'confirmed':
        color = Colors.blue;
        displayText = 'CONFIRMED';
        break;
      case 'cancelled':
        color = Colors.red;
        displayText = 'CANCELLED';
        break;
      case 'completed':
        color = Colors.grey;
        displayText = 'COMPLETED';
        break;
      default:
        color = Colors.grey;
        displayText = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEventDialog({Event? event}) {
    final nameController = TextEditingController(text: event?.title ?? '');
    final descriptionController = TextEditingController(
      text: event?.description ?? '',
    );
    final venueController = TextEditingController(text: event?.venue ?? '');
    final capacityController = TextEditingController(
      text: event?.capacity.toString() ?? '',
    );
    final generalPriceController = TextEditingController(
      text: event?.generalPrice.toString() ?? '',
    );
    final vipPriceController = TextEditingController(
      text: event?.vipPrice.toString() ?? '',
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
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              TextField(
                controller: venueController,
                decoration: InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: capacityController,
                decoration: InputDecoration(
                  labelText: 'Total Capacity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: generalPriceController,
                decoration: InputDecoration(
                  labelText: 'General Ticket Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: vipPriceController,
                decoration: InputDecoration(
                  labelText: 'VIP Ticket Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
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
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  venueController.text.isEmpty ||
                  capacityController.text.isEmpty ||
                  generalPriceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all required fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final adminProvider = context.read<AdminProvider>();
              bool success;

              if (event == null) {
                success = await adminProvider.addEvent(
                  name: nameController.text,
                  description: descriptionController.text,
                  date: selectedDate,
                  venue: venueController.text,
                  capacity: int.parse(capacityController.text),
                  price: double.parse(generalPriceController.text),
                  vipPrice: double.parse(
                    vipPriceController.text.isEmpty
                        ? generalPriceController.text
                        : vipPriceController.text,
                  ),
                );
              } else {
                success = await adminProvider.updateEvent(
                  id: event.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  date: selectedDate,
                  venue: venueController.text,
                  capacity: int.parse(capacityController.text),
                  price: double.parse(generalPriceController.text),
                  vipPrice: double.parse(
                    vipPriceController.text.isEmpty
                        ? generalPriceController.text
                        : vipPriceController.text,
                  ),
                );
              }

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      event == null
                          ? 'Event added successfully'
                          : 'Event updated successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
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
            onPressed: () async {
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Name and email are required'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final adminProvider = context.read<AdminProvider>();
              bool success;

              if (user == null) {
                success = await adminProvider.addUser(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                );
              } else {
                success = await adminProvider.updateUser(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                );
              }

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      user == null
                          ? 'User added successfully'
                          : 'User updated successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(user == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(String id) {
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
            onPressed: () async {
              Navigator.pop(context);

              final success = await context.read<AdminProvider>().deleteEvent(
                id,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String id) {
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
            onPressed: () async {
              Navigator.pop(context);

              final success = await context.read<AdminProvider>().deleteUser(
                id,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
