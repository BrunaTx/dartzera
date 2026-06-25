import 'subaccount_entity.dart';

class SubAccountMapper {
  static Map<String, dynamic> toMap(SubAccount subAccount) {
    return {
      'id': subAccount.id,
      'name': subAccount.name,
      'email': subAccount.email,
      'displayName': subAccount.displayName,
      'level': subAccount.level,
      'gold': subAccount.gold,
      'gems': subAccount.gems,
      'energy': subAccount.energy,
      'createdAt': subAccount.createdAt.toIso8601String(),
      'updatedAt': subAccount.updatedAt.toIso8601String(),
    };
  }

  static SubAccount fromMap(Map<String, dynamic> map) {
    return SubAccount(
      id: map['id'] as String,
      name: map['name'] as String,
      email: (map['email'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? '',
      level: map['level'] as int,
      gold: (map['gold'] as num).toDouble(),
      gems: map['gems'] as int,
      energy: map['energy'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
