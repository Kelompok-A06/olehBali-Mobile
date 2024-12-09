import 'package:flutter/material.dart';

class DeleteAccountConfirmationCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const DeleteAccountConfirmationCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text(
        'I understand that this action is permanent and cannot be undone',
        style: TextStyle(color: Colors.red),
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  final bool isConfirmed;
  final bool isLoading;
  final VoidCallback onPressed;

  const DeleteAccountButton({
    super.key,
    required this.isConfirmed,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isConfirmed && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : const Text(
              'Delete Account',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }
}

class DeleteAccountConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountConfirmationDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Final Confirmation'),
      content: const Text(
        'Are you absolutely sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}