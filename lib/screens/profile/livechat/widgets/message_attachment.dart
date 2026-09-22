import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class MessageAttachment extends StatelessWidget {
  final Future<void> Function()? onGallery;
  final Future<void> Function()? onCamera;
  final Future<void> Function()? onDocument;
  final Future<void> Function()? onAudio;
  final Future<void> Function()? onLocation;

  const MessageAttachment({
    super.key,
    this.onGallery,
    this.onCamera,
    this.onDocument,
    this.onAudio,
    this.onLocation,
  });

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Future<void> Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap == null ? null : () async {
        Navigator.pop(context);
        await onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A1F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Wrap(
          runSpacing: 24,
          spacing: MediaQuery.of(context).size.width * 0.1,
          alignment: WrapAlignment.center,
          children: [
            _buildOption(context, Boxicons.bx_image, 'Gallery', Colors.purple, onGallery),
            _buildOption(context, Boxicons.bx_camera, 'Camera', Colors.pink, onCamera),
            _buildOption(context, Boxicons.bx_file, 'Document', Colors.blue, onDocument),
            _buildOption(
              context,
              Boxicons.bx_microphone,
              'Audio',
              Colors.orange,
              onAudio,
            ),
            _buildOption(context, Boxicons.bx_map, 'Location', Colors.green, onLocation),
          ],
        ),
      ),
    );
  }
}
