class UserRewardModel {
  final String userId; // Unique ID of the user
  final int totalPoints; // Current points the user has
  final int totalPointsAccumulated; // Total points earned by the user since joining
  final String tier; // Tier of the user (e.g., Bronze, Silver, Gold)
  final List<String> redeemedRewards; // List of reward IDs the user has redeemed
  final DateTime lastUpdated; // Timestamp of the last points update

  // Constructor
  UserRewardModel({
    required this.userId,
    required this.totalPoints,
    required this.totalPointsAccumulated,
    required this.tier,
    required this.redeemedRewards,
    required this.lastUpdated,
  });

  // Convert UserRewardModel to a Map (for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'totalPointsAccumulated': totalPointsAccumulated,
      'tier': tier,
      'redeemedRewards': redeemedRewards,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create a UserRewardModel from a Map (for retrieving from Firestore)
  factory UserRewardModel.fromMap(Map<String, dynamic> map) {
    return UserRewardModel(
      userId: map['userId'] ?? '',
      totalPoints: map['totalPoints'] ?? 0,
      totalPointsAccumulated: map['totalPointsAccumulated'] ?? 0,
      tier: map['tier'] ?? 'Bronze', // Default to Bronze
      redeemedRewards: List<String>.from(map['redeemedRewards'] ?? []),
      lastUpdated: DateTime.parse(map['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  String toString() {
    return 'UserRewardModel(userId: $userId, totalPoints: $totalPoints, totalPointsAccumulated: $totalPointsAccumulated, tier: $tier, redeemedRewards: $redeemedRewards, lastUpdated: $lastUpdated)';
  }
}
