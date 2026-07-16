import 'dart:typed_data';

class UserProfile {
  String name;
  String handle;
  String? avatarPath;
  Uint8List? avatarBytes;
  int cardsGenerated;
  int tagsUsed;
  int daysActive;
  DateTime? firstOpenDate;

  UserProfile({
    this.name = 'Oulec',
    this.handle = 'oulec',
    this.avatarPath,
    this.avatarBytes,
    this.cardsGenerated = 0,
    this.tagsUsed = 0,
    this.daysActive = 0,
    this.firstOpenDate,
  });

  UserProfile copyWith({
    String? name,
    String? handle,
    String? avatarPath,
    Uint8List? avatarBytes,
    int? cardsGenerated,
    int? tagsUsed,
    int? daysActive,
    DateTime? firstOpenDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      cardsGenerated: cardsGenerated ?? this.cardsGenerated,
      tagsUsed: tagsUsed ?? this.tagsUsed,
      daysActive: daysActive ?? this.daysActive,
      firstOpenDate: firstOpenDate ?? this.firstOpenDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'handle': handle,
      'avatarPath': avatarPath,
      'cardsGenerated': cardsGenerated,
      'tagsUsed': tagsUsed,
      'daysActive': daysActive,
      'firstOpenDate': firstOpenDate?.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Oulec',
      handle: json['handle'] ?? 'oulec',
      avatarPath: json['avatarPath'],
      cardsGenerated: json['cardsGenerated'] ?? 0,
      tagsUsed: json['tagsUsed'] ?? 0,
      daysActive: json['daysActive'] ?? 0,
      firstOpenDate: json['firstOpenDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['firstOpenDate'])
          : null,
    );
  }
}
