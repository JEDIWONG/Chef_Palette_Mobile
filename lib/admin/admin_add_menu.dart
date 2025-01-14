import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chef_palette/admin/admin_addons_picker.dart';
import 'package:chef_palette/admin/admin_category_picker.dart';
import 'package:chef_palette/admin/admin_create_ingredients.dart';
import 'package:chef_palette/admin/admin_create_options.dart';
import 'package:chef_palette/models/product_model.dart';
import 'package:flutter/material.dart';

class AdminAddMenu extends StatefulWidget {
  const AdminAddMenu({super.key});

  @override
  State<AdminAddMenu> createState() => _AdminAddMenuState();
}

class _AdminAddMenuState extends State<AdminAddMenu> {
  String? selectedCategory;
  List<Map<String, dynamic>> addons = [];
  List<String> options = [];
  List<String> ingredients = [];
  File? _selectedImage; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  
  // Controllers to capture form inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();

  // Method to pick image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method to create a new product
  void _createProduct() async {
    final String name = nameController.text;
    final String description = descController.text;
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final int prepTime = int.tryParse(prepTimeController.text) ?? 10;

    // Create product model instance
    final ProductModel newProduct = ProductModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
      name: name,
      desc: description,
      price: price,
      imgUrl: _selectedImage?.path ?? '',
      category: selectedCategory ?? '',
      addons: addons,
      prepTime: prepTime,
      rating: 5.0, // Set default rating
      tags: [],
      ingredients: ingredients,
      options: options,
    );

    // Reference to the Firestore collection
    final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

    try {
      // Add the new product to Firestore
      await productsRef.doc(newProduct.uid).set(newProduct.toMap());
      print("Product Created: ${newProduct.name}, Price: RM ${newProduct.price}");

      // Clear form after creation
      setState(() {
        nameController.clear();
        descController.clear();
        priceController.clear();
        prepTimeController.clear();
        _selectedImage = null;
        selectedCategory = null;
        addons.clear();
        options.clear();
        ingredients.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "${newProduct.name}" added successfully!')),
      );
    } catch (e) {
      print('Error adding product: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Adding Menu"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: _pickImage, // Trigger image picker
                child: Container(
                  color: Colors.grey,
                  width: MediaQuery.sizeOf(context).width,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo_rounded),
                            Text("Upload Photo Here")
                          ],
                        )
                      : Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(label: Text("Product Name")),
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(label: Text("Description")),
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text("Price (RM)")),
              ),
              TextFormField(
                controller: prepTimeController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(label: Text("Prep Times in Minutes")),
              ),

              // Category Picker Section
              ListTile(
                title: Text(selectedCategory ?? "Select Category"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminCategoryPicker(
                        initialCategory: selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              // Add-Ons Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text("Add-Ons"),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_box),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAddOnsPage(
                              initialAddOns: addons,
                              onAddOnsUpdated: (updatedAddOns) {
                                setState(() {
                                  addons = updatedAddOns;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Display Added Add-Ons
                  ...addons.map((addon) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "- ${addon['name']} (RM ${addon['price'].toStringAsFixed(2)})",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ],
              ),

              // Options Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text("Options"),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_box),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminOptionsPage(
                              initialOptions: options,
                              onOptionsUpdated: (updatedOptions) {
                                setState(() {
                                  options = updatedOptions;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ...options.map((option) {
                    return Text(
                      "- $option",
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ],
              ),

              // Ingredients Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text("Ingredients"),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_box),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminIngredientsPage(
                              initialIngredients: ingredients,
                              onIngredientsUpdated: (updatedIngredients) {
                                setState(() {
                                  ingredients = updatedIngredients;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ...ingredients.map((ingredient) {
                    return Text(
                      "- $ingredient",
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  fixedSize: Size(MediaQuery.sizeOf(context).width, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: _createProduct, // Handle product creation
                child: const Text("Create Menu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
