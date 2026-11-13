import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

class AppProvider extends InheritedWidget {
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  final Student student;
  final List<Note> notes;
  final bool isLoading;
  final Function(Student) updateStudent;

  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;

  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider tidak ditemukan di widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student ||
        notes != oldWidget.notes ||
        isLoading != oldWidget.isLoading;
  }
}

class AppProviderWrapper extends StatefulWidget {
  const AppProviderWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repository = NoteRepository();

  Student _student = const Student(
    name: 'Latiffah Syukri Alliyah',
    nim: '26.21.1619',
    programStudi: 'Informatika',
    email: 'nama@students.amikom.ac.id',
  );
  List<Note> _notes = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await _repository.getNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat catatan: ${e.runtimeType}');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _updateStudent(Student student) {
    setState(() => _student = student);
  }

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (!mounted) return;
    setState(() => _notes = [note, ..._notes]);
  }

  Future<void> _deleteNote(String id) async {
    await _repository.deleteNote(id);
    if (!mounted) return;
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
