class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://your-api-url.com/api';
  static const String authEndpoint = '$baseUrl/auth';
  static const String eventsEndpoint = '$baseUrl/events';
  static const String ticketsEndpoint = '$baseUrl/tickets';
  static const String purchasesEndpoint = '$baseUrl/purchases';
  static const String usersEndpoint = '$baseUrl/users';
  static const String adminEndpoint = '$baseUrl/admin';

  // App Info
  static const String appName = 'EventTix';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // Payment Methods
  static const List<String> paymentMethods = [
    'eSewa',
    'Khalti',
    'Credit Card',
    'Debit Card',
  ];

  // Ticket Types
  static const String generalTicket = 'General';
  static const String vipTicket = 'VIP';

  // Ticket Status
  static const String ticketStatusActive = 'Active';
  static const String ticketStatusCancelled = 'Cancelled';
  static const String ticketStatusUsed = 'Used';

  // Event Status
  static const String eventStatusActive = 'active';
  static const String eventStatusSoldOut = 'sold_out';
  static const String eventStatusCancelled = 'cancelled';
  static const String eventStatusCompleted = 'completed';

  // Cancellation Policy
  static const int cancellationHoursBeforeEvent = 24;

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailAlreadyExists = 'Email already exists.';
  static const String ticketNotAvailable = 'Tickets are no longer available.';
  static const String cancellationNotAllowed =
      'Cancellation is not allowed within 24 hours of the event.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String signupSuccess = 'Account created successfully!';
  static const String ticketBookedSuccess = 'Ticket booked successfully!';
  static const String ticketCancelledSuccess = 'Ticket cancelled successfully!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
}
