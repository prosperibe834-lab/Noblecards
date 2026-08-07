// Where to paste: lib/screens/notification/widgets/notification_sound_tile.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class NotificationSoundTile extends StatelessWidget {
  final String soundName;
  final bool isSelected;
  final VoidCallback onSelect;

  const NotificationSoundTile({
    super.key,
    required this.soundName,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onSelect,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: IconButton(
        icon: Icon(Boxicons.bx_volume_full, color: isDark ? Colors.white54 : Colors.black54),
        onPressed: () {
          // Play sound preview simulation
        },
      ),
      title: Text(
        soundName,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Boxicons.bx_check, color: Color(0xFF00C853), size: 24)
          : Icon(Boxicons.bx_circle, color: isDark ? Colors.white24 : Colors.black26, size: 22),
    );
  }
}