import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {
  NoteRepository({SecureStorageService? secureStorage})
    : _secure = secureStorage ?? SecureStorageService();

  static const String _metaKey = 'notes_meta';
  final SecureStorageService _secure;

  Future<List<Map<String, dynamic>>> _readMeta() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metaKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } on FormatException {
      debugPrint('NoteRepository: metadata rusak, diabaikan');
      return [];
    }
  }

  Future<void> _writeMeta(List<Map<String, dynamic>> metas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metaKey, jsonEncode(metas));
  }

  Future<List<Note>> getNotes() async {
    final metas = await _readMeta();
    final notes = <Note>[];
    for (final meta in metas) {
      final content = await _secure.getContent(meta['id'] as String) ?? '';
      notes.add(Note.fromMeta(meta, content));
    }
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> addNote(Note note) async {
    await _secure.saveContent(note.id, note.content);
    final metas = await _readMeta();
    metas.add(note.toMeta());
    await _writeMeta(metas);
  }

  Future<void> deleteNote(String id) async {
    final metas = await _readMeta();
    metas.removeWhere((m) => m['id'] == id);
    await _writeMeta(metas);
    await _secure.deleteContent(id);
  }
}
