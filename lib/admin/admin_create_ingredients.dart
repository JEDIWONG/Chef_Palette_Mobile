import 'package:flutter/material.dart';

class AdminIngredientsPage extends StatefulWidget {
  final List<String> initialIngredients;
  final Function(List<String>) onIngredientsUpdated;

  const AdminIngredientsPage({
    Key? key,
    required this.initialIngredients,
    required this.onIngredientsUpdated,
  }) : super(key: key);

  @override
  State<AdminIngredientsPage> createState() => _AdminIngredientsPageState();
}

class _AdminIngredientsPageState extends State<AdminIngredientsPage> {
  List<String> ingredients = [];
  final TextEditingController ingredientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ingredients = List<String>.from(widget.initialIngredients);
  }

  void addIngredient() {
    final ingredient = ingredientController.text.trim();

    if (ingredient.isNotEmpty) {
      setState(() {
        ingredients.add(ingredient);
        ingredientController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingredient cannot be empty")),
      );
    }
  }

  void removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Ingredients"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onIngredientsUpdated(ingredients);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add New Ingredient Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ingredientController,
                    decoration: const InputDecoration(
                      labelText: "Ingredient Name",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addIngredient,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Ingredients
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ingredients[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeIngredient(index),
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
