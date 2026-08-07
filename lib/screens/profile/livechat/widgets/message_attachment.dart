import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class MessageAttachment extends StatelessWidget {
  const MessageAttachment({super.key});

  Widget _buildOption(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () => Navigator.pop(context), // Placeholder action
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
                  ? Colors.white70 : Colors.black87,
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
            _buildOption(context, Boxicons.bx_image, 'Gallery', Colors.purple),
            _buildOption(context, Boxicons.bx_camera, 'Camera', Colors.pink),
            _buildOption(context, Boxicons.bx_file, 'Document', Colors.blue),
            _buildOption(context, Boxicons.bx_microphone, 'Audio', Colors.orange),
            _buildOption(context, Boxicons.bx_map, 'Location', Colors.green),
          ],
        ),
      ),
    );
  }
}