class BranchModel{
  final double longitude;
  final double latitude;
  final String name;

  BranchModel({
    required this.longitude,
    required this.latitude,
    required this.name,
  });

  // Convert a Branch instance to a Map (for Firebase or JSON storage)
  Map<String, dynamic> toMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'name': name,
    };
  }

  // Create a Branch instance from a Map (e.g., from Firebase or JSON)
  factory BranchModel.fromMap(Map<dynamic, dynamic> map) {
    return BranchModel(
      longitude: map['longitude'] ?? '',
      latitude: map['latitude'] ?? '',
      name: map['name'] ?? '',
    );
  }

}