import 'package:flutter/material.dart';

class EditNameDialog extends StatefulWidget {
  final String currentFirstName;
  final String currentLastName;
  final Function(String firstName, String lastName) onSave;

  const EditNameDialog({
    super.key,
    required this.currentFirstName,
    required this.currentLastName,
    required this.onSave,
  });

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.currentFirstName);
    _lastNameController = TextEditingController(text: widget.currentLastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: "First Name"),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: "Last Name"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              _firstNameController.text,
              _lastNameController.text,
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
