// Where to paste: lib/screens/notification/widgets/swipe_notification_actions.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/notification_model.dart';

class SwipeNotificationActions extends StatelessWidget {
  final NotificationModel item;
  final Widget child;
  final VoidCallback onToggleRead;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const SwipeNotificationActions({
    super.key,
    required this.item,
    required this.child,
    required this.onToggleRead,
    required this.onTogglePin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Delete Notification"),
            content: const Text("Are you sure you want to remove this notification?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Delete", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Boxicons.bx_trash, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: child,
    );
  }
}