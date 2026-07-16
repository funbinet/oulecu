import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/card_config.dart';

class GeneratedCard {
  final int? id;
  final String filePath;
  final int timestamp;
  final String format;
  final int size;
  final List<String> tags;
  final String? topic;
  final String? subtopic;

  GeneratedCard({
    this.id,
    required this.filePath,
    required this.timestamp,
    required this.format,
    required this.size,
    this.tags = const [],
    this.topic,
    this.subtopic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'timestamp': timestamp,
      'format': format,
      'size': size,
      'tags': tags.join(','),
      'topic': topic,
      'subtopic': subtopic,
    };
  }

  factory GeneratedCard.fromMap(Map<String, dynamic> map) {
    return GeneratedCard(
      id: map['id'] as int?,
      filePath: map['filePath'] as String,
      timestamp: map['timestamp'] as int,
      format: map['format'] as String,
      size: map['size'] as int,
      tags: (map['tags'] as String? ?? '').isNotEmpty ? (map['tags'] as String).split(',') : [],
      topic: map['topic'] as String?,
      subtopic: map['subtopic'] as String?,
    );
  }
}

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbPathFile = path.join(dbPath, 'oulecu.db');

    return await openDatabase(
      dbPathFile,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE generated_cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            format TEXT NOT NULL,
            size INTEGER NOT NULL,
            tags TEXT,
            topic TEXT,
            subtopic TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE hashtags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tag TEXT UNIQUE NOT NULL,
            usage_count INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE presets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            config TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            is_default INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Generated Cards
  Future<int> insertGeneratedCard(GeneratedCard card) async {
    final db = await database;
    return await db.insert('generated_cards', card.toMap());
  }

  Future<List<GeneratedCard>> getAllGeneratedCards() async {
    final db = await database;
    final maps = await db.query('generated_cards', orderBy: 'timestamp DESC');
    return maps.map((m) => GeneratedCard.fromMap(m)).toList();
  }

  Future<List<GeneratedCard>> getGeneratedCardsByFormat(String format) async {
    final db = await database;
    final maps = await db.query(
      'generated_cards',
      where: 'format = ?',
      whereArgs: [format],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => GeneratedCard.fromMap(m)).toList();
  }

  Future<void> deleteGeneratedCard(int id) async {
    final db = await database;
    final card = await db.query('generated_cards', where: 'id = ?', whereArgs: [id]);
    if (card.isNotEmpty) {
      final filePath = card.first['filePath'] as String;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await db.delete('generated_cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllGeneratedCards() async {
    final db = await database;
    final cards = await db.query('generated_cards');
    for (final card in cards) {
      final filePath = card['filePath'] as String;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await db.delete('generated_cards');
  }

  // File Operations
  Future<String> getAppDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> getCacheDirectory() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  Future<String> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) return dir.path;
    }
    final dir = await getExternalStorageDirectory();
    return dir?.path ?? (await getApplicationDocumentsDirectory()).path;
  }

  Future<String> saveImage(Uint8List bytes, String fileName) async {
    final downloadsDir = await getDownloadsDirectory();
    final filePath = path.join(downloadsDir, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<String> saveTempImage(Uint8List bytes, String fileName) async {
    final cacheDir = await getCacheDirectory();
    final filePath = path.join(cacheDir, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<int> getCacheSize() async {
    final cacheDir = await getCacheDirectory();
    final dir = Directory(cacheDir);
    int totalSize = 0;
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    return totalSize;
  }

  Future<void> clearCache() async {
    final cacheDir = await getCacheDirectory();
    final dir = Directory(cacheDir);
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          await entity.delete();
        }
      }
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
