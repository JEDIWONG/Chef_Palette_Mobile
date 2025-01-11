class RewardModel {
  final String id; // Unique ID for the reward
  final String name; // Name of the reward (e.g., "Free Burger", "$5 Discount")
  final String description; // Description of the reward
  final int pointsRequired; // Points needed to redeem the reward
  final bool isActive; // Whether the reward is currently active or not
  final DateTime? expiryDate; // Optional: Expiry date of the reward
  final String type; // Type of reward (e.g., "Discount", "Free Item", "Voucher")
  final double? discountRate; // Discount rate (e.g., 10% = 0.10)
  final String? itemsFree; // Items free with this reward (e.g., "Free Burger")

  // Constructor
  RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.isActive,
    this.expiryDate,
    required this.type,
    this.discountRate,
    this.itemsFree,
  });

  // Convert RewardModel to a Map (for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pointsRequired': pointsRequired,
      'isActive': isActive,
      'expiryDate': expiryDate?.toIso8601String(),
      'type': type,
      'discountRate': discountRate,
      'itemsFree': itemsFree,
    };
  }

  // Create a RewardModel from a Map (for retrieving from Firestore)
  factory RewardModel.fromMap(Map<String, dynamic> map) {
    return RewardModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pointsRequired: map['pointsRequired'] ?? 0,
      isActive: map['isActive'] ?? false,
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : null,
      type: map['type'] ?? 'Other',
      discountRate: map['discountRate'] != null
          ? (map['discountRate'] as num).toDouble()
          : null,
      itemsFree: map['itemsFree'],
    );
  }

  @override
  String toString() {
    return 'RewardModel(id: $id, name: $name, description: $description, pointsRequired: $pointsRequired, isActive: $isActive, expiryDate: $expiryDate, type: $type, discountRate: $discountRate, itemsFree: $itemsFree)';
  }
}
