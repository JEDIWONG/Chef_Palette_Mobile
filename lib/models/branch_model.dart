class BranchModel{
  final String state;
  final String city;
  final String branchName;

  BranchModel({
    required this.state,
    required this.city,
    required this.branchName,
  });

  // Convert a Branch instance to a Map (for Firebase or JSON storage)
  Map<String, dynamic> toMap() {
    return {
      'state': state,
      'city': city,
      'branchName': branchName,
    };
  }

  // Create a Branch instance from a Map (e.g., from Firebase or JSON)
  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      branchName: map['branchName'] ?? '',
    );
  }

}
