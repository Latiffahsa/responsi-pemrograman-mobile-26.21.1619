import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static String _key(String noteId) => 'note_content_$noteId';

  Future<void> saveContent(String noteId, String content) {
    return _storage.write(key: _key(noteId), value: content);
  }

  Future<String?> getContent(String noteId) {
    return _storage.read(key: _key(noteId));
  }

  Future<void> deleteContent(String noteId) {
    return _storage.delete(key: _key(noteId));
  }
}
