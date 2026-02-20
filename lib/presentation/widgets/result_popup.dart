import 'package:flutter/material.dart';

enum ResultType { success, error }

class ResultPopup extends StatelessWidget {
  const ResultPopup({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.buttonLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final ResultType type;
  final String buttonLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final color = type == ResultType.success ? Colors.green : Colors.red;
    final icon = type == ResultType.success ? Icons.check_circle : Icons.error;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onAction,
            child: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}
