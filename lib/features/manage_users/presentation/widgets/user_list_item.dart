
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';

class UserListItem extends StatelessWidget {
  final UserEntity user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final statusColor = user.status == 'active' ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.1),
        child: Text(
          user.name.substring(0, 1).toUpperCase(),
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(user.email),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          user.status.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}