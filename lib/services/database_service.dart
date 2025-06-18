import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/emergency_contact.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError(
          'SQLite database is not supported on web platform');
    }

    try {
      // Initialize FFI for desktop platforms
      if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'emergency_contacts.db');

      // Ensure the directory exists
      try {
        await Directory(databasesPath).create(recursive: true);
      } catch (e) {
        debugPrint('Error creating database directory: $e');
      }

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) async {
          debugPrint('Database opened successfully at $path');
        },
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS emergency_contacts(
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          phoneNumber TEXT NOT NULL,
          relationship TEXT NOT NULL,
          isPrimaryContact INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT
        )
      ''');
      debugPrint('Emergency contacts table created successfully');
    } catch (e) {
      debugPrint('Error creating emergency contacts table: $e');
      rethrow;
    }
  }

  Future<List<EmergencyContact>> getPrimaryContacts() async {
    try {
      if (kIsWeb) {
        // Return empty list for web platform
        return [];
      }
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'emergency_contacts',
        where: 'isPrimaryContact = ?',
        whereArgs: [1],
      );
      return maps.map((map) => EmergencyContact.fromMap(map)).toList();
    } catch (e) {
      print('Error getting primary contacts: $e');
      return [];
    }
  }

  Future<List<EmergencyContact>> getAllContacts() async {
    try {
      if (kIsWeb) {
        return [];
      }
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('emergency_contacts', orderBy: 'isPrimaryContact DESC, name ASC');
      return maps.map((map) => EmergencyContact.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error getting all contacts: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  Future<String> insertContact(EmergencyContact contact) async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite database is not supported on web platform');
    }
    
    final db = await database;
    await db.transaction((txn) async {
      // If this contact is primary, remove primary flag from other contacts
      if (contact.isPrimaryContact) {
        await txn.update(
          'emergency_contacts',
          {'isPrimaryContact': 0},
          where: 'id != ?',
          whereArgs: [contact.id],
        );
      }
      
      await txn.insert(
        'emergency_contacts',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    
    return contact.id;
  }

  Future<int> updateContact(EmergencyContact contact) async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite database is not supported on web platform');
    }
    
    final db = await database;
    return await db.transaction((txn) async {
      // If this contact is primary, remove primary flag from other contacts
      if (contact.isPrimaryContact) {
        await txn.update(
          'emergency_contacts',
          {'isPrimaryContact': 0},
          where: 'id != ?',
          whereArgs: [contact.id],
        );
      }
      
      return await txn.update(
        'emergency_contacts',
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
    });
  }

  Future<int> deleteContact(String id) async {
    if (kIsWeb) {
      throw UnsupportedError(
          'SQLite database is not supported on web platform');
    }
    final db = await database;
    return await db.delete(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<EmergencyContact?> getContact(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return EmergencyContact.fromMap(maps.first);
  }
}
