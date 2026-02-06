/// User model for ALU Academic Assistant
class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String studentId;
  final String campusLocation;
  final String academicYear;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.studentId,
    required this.campusLocation,
    required this.academicYear,
  });

  /// Create User from Map (for storage)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      studentId: map['studentId'] as String,
      campusLocation: map['campusLocation'] as String,
      academicYear: map['academicYear'] as String,
    );
  }

  /// Convert User to Map (for storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'studentId': studentId,
      'campusLocation': campusLocation,
      'academicYear': academicYear,
    };
  }
}
