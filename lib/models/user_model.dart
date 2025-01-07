class UserModel {
  String uid;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String dob;
  String joinDate;
  String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dob,
    required this.joinDate,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email':email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dob':dob,
      'joinDate':joinDate,
      'role':role,
    };
  }
}