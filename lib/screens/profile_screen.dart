import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Layar profil mahasiswa beserta tombol edit.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // DIUBAH: sebelumnya _showEditDialog memakai showDialog.
  Future<void> _openEditScreen(BuildContext context) async {
    final provider = AppProvider.of(context);
    final updated = await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (_) => _EditProfileScreen(student: provider.student),
      ),
    );
    if (updated != null) {
      provider.updateStudent(updated);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileCard(student: student),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _openEditScreen(context), // DIUBAH
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}

// DIUBAH: sebelumnya _EditProfileDialog (AlertDialog), sekarang layar penuh.
class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen({required this.student});

  final Student student;

  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nim;
  late final TextEditingController _prodi;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.student.name);
    _nim = TextEditingController(text: widget.student.nim);
    _prodi = TextEditingController(text: widget.student.programStudi);
    _email = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _prodi.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        name: Validators.sanitize(_name.text),
        nim: Validators.sanitize(_nim.text),
        programStudi: Validators.sanitize(_prodi.text),
        email: Validators.sanitize(_email.text),
      ),
    );
  }

  // DIUBAH: build ditulis ulang menjadi Scaffold layar penuh.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => Validators.validateRequired(v, 'Nama'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nim,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (v) => Validators.validateRequired(v, 'NIM'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prodi,
                decoration: const InputDecoration(labelText: 'Program Studi'),
                validator: (v) =>
                    Validators.validateRequired(v, 'Program studi'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
