import 'package:flutter/material.dart';

class AvatarPreviewDialog extends StatelessWidget {
  final String url;
  const AvatarPreviewDialog({super.key, required this.url});

  
static void show(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AvatarPreviewDialog(url: url,));
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Avatar Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(url),
              onBackgroundImageError: (_, __) {
                // Error loading image
              },
              child: null,
            ),
            const SizedBox(height: 16),
            Text(
              'This is how the avatar will appear',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
  }
}

