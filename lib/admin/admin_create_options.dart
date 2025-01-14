import 'package:flutter/material.dart';

class AdminOptionsPage extends StatefulWidget {
  final List<String> initialOptions;
  final Function(List<String>) onOptionsUpdated;

  const AdminOptionsPage({
    Key? key,
    required this.initialOptions,
    required this.onOptionsUpdated,
  }) : super(key: key);

  @override
  State<AdminOptionsPage> createState() => _AdminOptionsPageState();
}

class _AdminOptionsPageState extends State<AdminOptionsPage> {
  List<String> options = [];
  final TextEditingController optionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    options = List<String>.from(widget.initialOptions);
  }

  void addOption() {
    final option = optionController.text.trim();

    if (option.isNotEmpty) {
      setState(() {
        options.add(option);
        optionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Option cannot be empty")),
      );
    }
  }

  void removeOption(int index) {
    setState(() {
      options.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Options"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onOptionsUpdated(options);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add New Option Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: optionController,
                    decoration: const InputDecoration(
                      labelText: "Option Name",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addOption,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Options
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeOption(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
