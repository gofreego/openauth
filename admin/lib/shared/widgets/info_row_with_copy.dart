import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/toast_utils.dart';

class InfoRowWithCopy extends StatelessWidget {
  final String label;
  final String value;
  final bool copy;

  const InfoRowWithCopy({super.key, required this.label, required this.value, this.copy = false});

  @override
  Widget build(BuildContext context) {
     void copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    CopyToast.show(label);
  }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
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