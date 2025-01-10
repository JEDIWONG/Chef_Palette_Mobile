import 'package:flutter/material.dart';

class NoOfPersonPickerPopout extends StatefulWidget {
  final Function(int) onPersonSelected;

  const NoOfPersonPickerPopout({super.key, required this.onPersonSelected});

  @override
  _NoOfPersonPickerPopoutState createState() => _NoOfPersonPickerPopoutState();
}

class _NoOfPersonPickerPopoutState extends State<NoOfPersonPickerPopout> {
  int selectedPerson = 1; // Initial value

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Number of Persons"),
      content: DropdownButton<int>(
        value: selectedPerson,
        items: List.generate(20, (index) {
          return DropdownMenuItem<int>(
            value: index + 1,
            child: Text("${index + 1}"),
          );
        }),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedPerson = value; // Update selected number dynamically
            });
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onPersonSelected(selectedPerson); // Pass the selected value
            Navigator.pop(context);
          },
          child: const Text("Confirm"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
