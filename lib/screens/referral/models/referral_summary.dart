class ReferralReward {
  final String id;
  final String referredName;
  final double amountUsd;
  final String status;
  final DateTime? createdAt;
  final DateTime? creditedAt;

  const ReferralReward({
    required this.id,
    required this.referredName,
    required this.amountUsd,
    required this.status,
    this.createdAt,
    this.creditedAt,
  });

  factory ReferralReward.fromJson(Map<String, dynamic> json) {
    return ReferralReward(
      id: _requiredString(json, 'id'),
      referredName: _requiredString(json, 'referredName'),
      amountUsd: _requiredAmount(json, 'amountUsd'),
      status: _requiredString(json, 'status'),
      createdAt: _date(json['createdAt']),
      creditedAt: _date(json['creditedAt']),
    );
  }
}

class ReferralSummary {
  final String code;
  final String link;
  final int invitedCount;
  final int qualifiedCount;
  final double pendingRewardUsd;
  final double heldRewardUsd;
  final double availableRewardUsd;
  final int pendingRewardCount;
  final int heldRewardCount;
  final List<ReferralReward> rewardHistory;

  const ReferralSummary({
    required this.code,
    required this.link,
    required this.invitedCount,
    required this.qualifiedCount,
    required this.pendingRewardUsd,
    required this.heldRewardUsd,
    required this.availableRewardUsd,
    required this.pendingRewardCount,
    required this.heldRewardCount,
    required this.rewardHistory,
  });

  factory ReferralSummary.fromJson(Map<String, dynamic> json) {
    final historyJson = json['rewardHistory'];
    if (historyJson is! List) {
      throw const FormatException('Referral reward history is invalid.');
    }
    return ReferralSummary(
      code: _requiredString(json, 'code'),
      link: _requiredString(json, 'link'),
      invitedCount: _requiredInt(json, 'invitedCount'),
      qualifiedCount: _requiredInt(json, 'qualifiedCount'),
      pendingRewardUsd: _requiredAmount(json, 'pendingRewardUsd'),
      heldRewardUsd: _requiredAmount(json, 'heldRewardUsd'),
      availableRewardUsd: _requiredAmount(json, 'availableRewardUsd'),
      pendingRewardCount: _requiredInt(json, 'pendingRewardCount'),
      heldRewardCount: _requiredInt(json, 'heldRewardCount'),
      rewardHistory: historyJson
          .map((item) {
            if (item is! Map) {
              throw const FormatException('Referral reward entry is invalid.');
            }
            return ReferralReward.fromJson(Map<String, dynamic>.from(item));
          })
          .toList(growable: false),
    );
  }

  double get totalEarnedUsd => rewardHistory
      .where(
        (reward) =>
            reward.status == 'AVAILABLE' ||
            reward.status == 'PENDING' ||
            reward.status == 'HELD',
      )
      .fold(0, (total, reward) => total + reward.amountUsd);
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Referral response field "$key" is invalid.');
  }
  return value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int || value < 0) {
    throw FormatException('Referral response field "$key" is invalid.');
  }
  return value;
}

double _requiredAmount(Map<String, dynamic> json, String key) {
  final value = json[key];
  final amount = value is num ? value.toDouble() : double.tryParse('$value');
  if (amount == null || !amount.isFinite || amount < 0) {
    throw FormatException('Referral response field "$key" is invalid.');
  }
  return amount;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  if (value is! String) {
    throw const FormatException('Referral reward date is invalid.');
  }
  return DateTime.tryParse(value);
}
