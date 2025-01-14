// ignore_for_file: avoid_print

import 'dart:collection';
import 'package:chef_palette/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductController extends ChangeNotifier {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Private list of products
  final List<ProductModel> _products = [];

  // Getter for unmodifiable view of products
  UnmodifiableListView<ProductModel> get products => UnmodifiableListView(_products);

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      _products.clear();
      for (var doc in snapshot.docs) {
        _products.add(ProductModel.fromMap(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Add a new product to Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.uid).set(product.toMap());
      _products.add(product);
      notifyListeners(); // Notify listeners about the change
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Remove a product from Firestore by UID
  Future<void> removeProduct(String uid) async {
    try {
      await _firestore.collection('products').doc(uid).delete();
      _products.removeWhere((product) => product.uid == uid);
      notifyListeners(); // Notify listeners about the change
    } catch (e) {
      print('Error removing product: $e');
    }
  }

  // Update a product in Firestore by UID
  Future<void> updateProduct(String uid, ProductModel updatedProduct) async {
    try {
      await _firestore.collection('products').doc(uid).update(updatedProduct.toMap());
      int index = _products.indexWhere((product) => product.uid == uid);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners(); // Notify listeners about the change
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Get a product by UID
  ProductModel? getProductById(String uid) {
    return _products.firstWhere((product) => product.uid == uid,);
  }
  
  // Filter products by category
  List<ProductModel> filterByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Search products by name
  List<ProductModel> searchByName(String query) {
    return _products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Toggle availability of a product
  Future<void> toggleAvailability(String uid) async {
    try {
      int index = _products.indexWhere((product) => product.uid == uid);
      if (index != -1) {
        bool newAvailability = !_products[index].isAvailable;
        await _firestore.collection('products').doc(uid).update({'isAvailable': newAvailability});
        _products[index].isAvailable = newAvailability;
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling availability: $e');
    }
  }

  // Sort products by price (ascending)
  void sortByPriceAscending() {
    _products.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  // Sort products by rating (descending)
  void sortByRatingDescending() {
    _products.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  // Clear all products
  void clearAllProducts() {
    _products.clear();
    notifyListeners();
  }
}
