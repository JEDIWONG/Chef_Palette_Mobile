import 'package:flutter/material.dart';

class DatePickerPopout extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerPopout({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select a Date"),
      content: SizedBox(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (selectedDate) {
                      onDateSelected(selectedDate);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close"),
        ),
      ],
    );
  }
}
