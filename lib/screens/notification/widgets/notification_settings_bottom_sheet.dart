// Where to paste: lib/screens/notification/widgets/notification_settings_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'notification_sound_tile.dart';

class NotificationSettingsBottomSheet extends StatefulWidget {
  const NotificationSettingsBottomSheet({super.key});

  @override
  State<NotificationSettingsBottomSheet> createState() =>
      _NotificationSettingsBottomSheetState();
}

class _NotificationSettingsBottomSheetState
    extends State<NotificationSettingsBottomSheet> {
  String _selectedSound = "Fintech";

  final List<String> _sounds = [
    "Classic",
    "Crystal",
    "Fintech",
    "Soft Bell",
    "Pulse",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12181F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Notification Sound",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._sounds.map((sound) => NotificationSoundTile(
                soundName: sound,
                isSelected: _selectedSound == sound,
                onSelect: () {
                  setState(() {
                    _selectedSound = sound;
                  });
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}