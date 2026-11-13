import 'package:flutter/material.dart';

import '../models/student.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                student.initials,
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.badge, label: 'NIM', value: student.nim),
            _InfoRow(
              icon: Icons.school,
              label: 'Program Studi',
              value: student.programStudi,
            ),
            _InfoRow(icon: Icons.email, label: 'Email', value: student.email),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
