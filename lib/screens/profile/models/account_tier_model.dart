class AccountTierModel {
  final String currentTier;
  final String nextTier;
  final int currentPoints;
  final int requiredPoints;
  final double progressPercentage;
  final double dailyLimit;
  final double remainingDailyLimit;
  final AccountStats stats;
  final List<TierConfig> allTiers;

  AccountTierModel({
    required this.currentTier,
    required this.nextTier,
    required this.currentPoints,
    required this.requiredPoints,
    required this.progressPercentage,
    required this.dailyLimit,
    required this.remainingDailyLimit,
    required this.stats,
    required this.allTiers,
  });

  factory AccountTierModel.fromJson(Map<String, dynamic> json) {
    return AccountTierModel(
      currentTier: json['currentTier']?.toString() ?? 'Bronze',
      nextTier: json['nextTier']?.toString() ?? 'Silver',
      currentPoints: (json['currentPoints'] as num?)?.toInt() ?? 0,
      requiredPoints: (json['requiredPoints'] as num?)?.toInt() ?? 500,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      dailyLimit: (json['dailyLimit'] as num?)?.toDouble() ?? 2000.0,
      remainingDailyLimit: (json['remainingDailyLimit'] as num?)?.toDouble() ?? 2000.0,
      stats: AccountStats.fromJson(
        json['stats'] is Map ? Map<String, dynamic>.from(json['stats']) : {},
      ),
      allTiers: (json['allTiers'] as List?)
              ?.map((t) => TierConfig.fromJson(Map<String, dynamic>.from(t)))
              .toList() ??
          [],
    );
  }

  // Mock data to simulate backend response
  static AccountTierModel get mockData => AccountTierModel(
    currentTier: "Gold",
    nextTier: "Platinum",
    currentPoints: 2200,
    requiredPoints: 3000,
    progressPercentage: 0.78,
    dailyLimit: 10000,
    remainingDailyLimit: 6800,
    stats: AccountStats(
      totalPoints: 2200,
      memberSince: "May 12, 2024",
      memberDuration: "1 year, 2 months",
      successfulTransactions: 142,
      totalVolume: 18450,
    ),
    allTiers: [
      TierConfig(
        name: "Bronze",
        minPoints: 0,
        maxPoints: 499,
        dailyLimit: 2000,
      ),
      TierConfig(
        name: "Silver",
        minPoints: 500,
        maxPoints: 1499,
        dailyLimit: 5000,
      ),
      TierConfig(
        name: "Gold",
        minPoints: 1500,
        maxPoints: 2999,
        dailyLimit: 10000,
      ),
      TierConfig(
        name: "Platinum",
        minPoints: 3000,
        maxPoints: 7499,
        dailyLimit: 25000,
      ),
      TierConfig(
        name: "Diamond",
        minPoints: 7500,
        maxPoints: 99999,
        dailyLimit: 50000,
      ),
    ],
  );
}

class AccountStats {
  final int totalPoints;
  final String memberSince;
  final String memberDuration;
  final int successfulTransactions;
  final double totalVolume;

  AccountStats({
    required this.totalPoints,
    required this.memberSince,
    this.memberDuration = '',
    required this.successfulTransactions,
    required this.totalVolume,
  });

  factory AccountStats.fromJson(Map<String, dynamic> json) {
    return AccountStats(
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      memberSince: json['memberSince']?.toString() ?? '',
      memberDuration: json['memberDuration']?.toString() ?? '',
      successfulTransactions: (json['successfulTransactions'] as num?)?.toInt() ?? 0,
      totalVolume: (json['totalVolume'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TierConfig {
  final String name;
  final int minPoints;
  final int maxPoints;
  final double dailyLimit;

  TierConfig({
    required this.name,
    required this.minPoints,
    required this.maxPoints,
    required this.dailyLimit,
  });

  factory TierConfig.fromJson(Map<String, dynamic> json) {
    return TierConfig(
      name: json['name']?.toString() ?? '',
      minPoints: (json['minPoints'] as num?)?.toInt() ?? 0,
      maxPoints: (json['maxPoints'] as num?)?.toInt() ?? 0,
      dailyLimit: (json['dailyLimit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
