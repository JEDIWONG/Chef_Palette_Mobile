import 'package:flutter/material.dart';

class AdminCategoryPicker extends StatefulWidget {
  final String? initialCategory;
  final Function(String) onCategorySelected;

  const AdminCategoryPicker({
    Key? key,
    this.initialCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<AdminCategoryPicker> createState() => _AdminCategoryPickerState();
}

class _AdminCategoryPickerState extends State<AdminCategoryPicker> {
  final List<String> categories = ["Beverages", "Desserts", "Main Course"];
  final TextEditingController newCategoryController = TextEditingController();

  void addNewCategory() {
    if (newCategoryController.text.isNotEmpty) {
      setState(() {
        categories.add(newCategoryController.text.trim());
        newCategoryController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display List of Categories
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index]),
                    trailing: widget.initialCategory == categories[index]
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      widget.onCategorySelected(categories[index]);
                      Navigator.pop(context);
                    },
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
