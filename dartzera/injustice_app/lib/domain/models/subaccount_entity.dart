import 'package:equatable/equatable.dart';

class SubAccount extends Equatable {
  final String id;
  final String name;
  final String email;
  final String displayName;
  final int level;
  final double gold;
  final int gems;
  final int energy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.displayName,
    required this.level,
    required this.gold,
    required this.gems,
    required this.energy,
    required this.createdAt,
    required this.updatedAt,
  });

  SubAccount copyWith({
    String? id,
    String? name,
    String? email,
    String? displayName,
    int? level,
    double? gold,
    int? gems,
    int? energy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      level: level ?? this.level,
      gold: gold ?? this.gold,
      gems: gems ?? this.gems,
      energy: energy ?? this.energy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, email, displayName,
        level, gold, gems, energy,
        createdAt, updatedAt,
      ];

  @override
  String toString() =>
      'SubAccount(id: $id, name: $name, email: $email, displayName: $displayName, level: $level)';
}
