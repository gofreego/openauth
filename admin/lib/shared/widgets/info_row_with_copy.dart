import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoRowWithCopy extends StatelessWidget {
  final String label;
  final String value;
  final bool copy;

  const InfoRowWithCopy({super.key, required this.label, required this.value, this.copy = false});

  @override
  Widget build(BuildContext context) {
     void copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (copy)
                IconButton(
                  onPressed: () => copyToClipboard(value, label),
                  icon: const Icon(Icons.copy, size: 16),
                  tooltip: 'Copy $label',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 
}