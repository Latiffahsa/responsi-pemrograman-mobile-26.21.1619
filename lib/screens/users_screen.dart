import 'package:flutter/material.dart';

import '../services/api_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService _api = ApiService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchUsers();
  }

  void _retry() => setState(() => _future = _api.fetchUsers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Pengguna (API)')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _retry,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }
          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${u['id']}')),
                title: Text('${u['name']}'),
                subtitle: Text('${u['email']}'),
              );
            },
          );
        },
      ),
    );
  }
}
