import 'package:flutter/material.dart';

class AdminAddOnsPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialAddOns;
  final Function(List<Map<String, dynamic>>) onAddOnsUpdated;

  const AdminAddOnsPage({
    Key? key,
    required this.initialAddOns,
    required this.onAddOnsUpdated,
  }) : super(key: key);

  @override
  State<AdminAddOnsPage> createState() => _AdminAddOnsPageState();
}

class _AdminAddOnsPageState extends State<AdminAddOnsPage> {
  List<Map<String, dynamic>> addOns = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addOns = List<Map<String, dynamic>>.from(widget.initialAddOns);
  }

  void addNewAddOn() {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (name.isNotEmpty && price != null) {
      setState(() {
        addOns.add({'name': name, 'price': price});
        nameController.clear();
        priceController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid name and price")),
      );
    }
  }

  void removeAddOn(int index) {
    setState(() {
      addOns.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Add-Ons"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onAddOnsUpdated(addOns);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add New Add-On Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Add-On Name",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price (RM)",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addNewAddOn,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Add-Ons
            Expanded(
              child: ListView.builder(
                itemCount: addOns.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addOns[index]['name']),
                    subtitle: Text("RM ${addOns[index]['price'].toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeAddOn(index),
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
