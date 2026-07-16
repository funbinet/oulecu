import 'settings_service.dart';
import '../utils/constants.dart';

class HashtagService {
  static final HashtagService _instance = HashtagService._internal();
  factory HashtagService() => _instance;
  HashtagService._internal();

  final SettingsService _settings = SettingsService();

  List<String> getAllHashtags() {
    return _settings.getHashtags();
  }

  List<String> searchHashtags(String query) {
    final allTags = getAllHashtags();
    if (query.isEmpty) return allTags;
    final cleanQuery = query.replaceAll('#', '').toLowerCase();
    return allTags.where((tag) => tag.toLowerCase().contains(cleanQuery)).toList();
  }

  Future<void> addHashtag(String tag) async {
    final cleanTag = tag.replaceAll('#', '').trim().toLowerCase();
    if (cleanTag.isNotEmpty && cleanTag.length <= 30) {
      await _settings.addHashtag(cleanTag);
    }
  }

  Future<void> removeHashtag(String tag) async {
    await _settings.removeHashtag(tag);
  }

  Future<void> addMultipleHashtags(List<String> tags) async {
    for (final tag in tags) {
      await addHashtag(tag);
    }
  }

  String formatHashtag(String tag) {
    final clean = tag.replaceAll('#', '').trim().toLowerCase();
    return clean.isNotEmpty ? '#$clean' : '';
  }

  List<String> formatHashtags(List<String> tags) {
    return tags.map(formatHashtag).where((t) => t.isNotEmpty).toList();
  }

  Future<void> resetToDefaults() async {
    await _settings.setHashtags(List.from(AppConstants.defaultHashtags));
  }

  bool isAtLimit(List<String> currentTags) {
    return currentTags.length >= AppConstants.maxHashtags;
  }

  int get remainingSlots => AppConstants.maxHashtags;
}
