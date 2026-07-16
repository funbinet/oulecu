import 'card_config.dart';

class Preset {
  final String id;
  final String name;
  final CardConfig config;
  final DateTime createdAt;
  bool isDefault;

  Preset({
    required this.id,
    required this.name,
    required this.config,
    required this.createdAt,
    this.isDefault = false,
  });

  Preset copyWith({
    String? id,
    String? name,
    CardConfig? config,
    DateTime? createdAt,
    bool? isDefault,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'config': config.toJson(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isDefault': isDefault,
    };
  }

  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      config: CardConfig.fromJson(json['config'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      isDefault: json['isDefault'] ?? false,
    );
  }
}
