class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final bool isAdmin;
  final int totalPurchases;
  final double totalSpent;
  final DateTime joinDate;
  final DateTime? lastLogin;
  final bool isActive;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.isAdmin = false,
    this.totalPurchases = 0,
    this.totalSpent = 0.0,
    DateTime? joinDate,
    this.lastLogin,
    this.isActive = true,
    this.token,
  }) : joinDate = joinDate ?? DateTime.now();

  // Get display name
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  // Get initials for avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  // Check if user has completed profile
  bool get hasCompletedProfile => phone != null && phone!.isNotEmpty;

  // Copy with method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    bool? isAdmin,
    int? totalPurchases,
    double? totalSpent,
    DateTime? joinDate,
    DateTime? lastLogin,
    bool? isActive,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      isAdmin: isAdmin ?? this.isAdmin,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalSpent: totalSpent ?? this.totalSpent,
      joinDate: joinDate ?? this.joinDate,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'isAdmin': isAdmin,
      'totalPurchases': totalPurchases,
      'totalSpent': totalSpent,
      'joinDate': joinDate.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      // Don't include token in JSON for security
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      isAdmin: json['isAdmin'] ?? false,
      totalPurchases: json['totalPurchases'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
      isActive: json['isActive'] ?? true,
      token: json['token'],
    );
  }
}
