// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chef_palette/models/product_model.dart';
import 'package:chef_palette/admin/admin_category_picker.dart';

class AdminUpdateMenu extends StatefulWidget {
  final String productId;
  const AdminUpdateMenu({required this.productId, super.key});

  @override
  State<AdminUpdateMenu> createState() => _AdminUpdateMenuState();
}

class _AdminUpdateMenuState extends State<AdminUpdateMenu> {
  String? selectedCategory;
  List<Map<String, dynamic>> addons = [];
  List<String> options = [];
  List<String> ingredients = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    final DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();

    if (productDoc.exists) {
      final productData = productDoc.data() as Map<String, dynamic>;
      final ProductModel product = ProductModel.fromMap(productData);

      setState(() {
        nameController.text = product.name;
        descController.text = product.desc;
        priceController.text = product.price.toString();
        prepTimeController.text = product.prepTime.toString();
        selectedCategory = product.category;
        addons = product.addons;
        options = product.options;
        ingredients = product.ingredients;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File imageFile = File(image.path);

      if (await _isValidImage(imageFile)) {
        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid image. Please upload a PNG/JPG image smaller than 1MB.')),
        );
      }
    }
  }

  Future<bool> _isValidImage(File image) async {
    final int maxSizeInBytes = 1 * 1024 * 1024; // 1MB
    final String extension = image.path.split('.').last.toLowerCase();
    final int imageSize = await image.length();
    return (imageSize <= maxSizeInBytes) && (extension == 'png' || extension == 'jpg');
  }

  Future<String> _uploadImageToFirebase(File imageFile, String productId) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String imagePath = 'assets/images/prod_$productId.png';
      final Reference ref = storage.ref().child(imagePath);

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  Future<void> _updateProduct() async {
    final String name = nameController.text;
    final String description = descController.text;
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final int prepTime = int.tryParse(prepTimeController.text) ?? 10;

    final DocumentReference productRef =
        FirebaseFirestore.instance.collection('products').doc(widget.productId);

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToFirebase(_selectedImage!, widget.productId);
      }

      await productRef.update({
        'name': name,
        'desc': description,
        'price': price,
        'prepTime': prepTime,
        'category': selectedCategory ?? '',
        'addons': addons,
        'ingredients': ingredients,
        'options': options,
        if (imageUrl != null) 'imgUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating product.')),
      );
    }
  }

  Future<void> _deleteProduct() async {
    try {
      // Reference to the Firestore collection
      final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

      // Delete product by product ID
      await productsRef.doc(widget.productId).delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully!")),
      );

      // Navigate back or refresh the page
      Navigator.of(context).pop();
    } catch (e) {
      // Handle error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete product: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Menu'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          final bool? confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: const Text("Are you sure you want to delete this product? This action cannot be undone."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Close the dialog and return false
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // Close the dialog and return true
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmDelete == true) {
                            // Call the delete function here
                            await _deleteProduct(); // Replace with your delete function
                          }
                        },
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ),

                    
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        color: Colors.grey,
                        width: MediaQuery.sizeOf(context).width,
                        height: 200,
                        margin: const EdgeInsets.only(top: 20,bottom: 30),
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo_rounded),
                                  Text("Update Photo"),
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
                      decoration: const InputDecoration(label: Text("Prep Times in Minutes")),
                    ),
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
                    ElevatedButton(
                      onPressed: _updateProduct,
                      child: const Text('Update Menu'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
