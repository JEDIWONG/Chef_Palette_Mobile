// ignore_for_file: avoid_print

import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/cart_model.dart';
import 'package:chef_palette/models/product.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try { 
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      CartModel newCart = CartModel(uid: user.uid, items: []);
      await _firestore.collection('carts').doc(user.uid).set(newCart.toMap());
      
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      // Fetch user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =  await _firestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        if (data != null) {
  //save the data in the user model
          return UserModel(
            uid: data['uid'] as String,
            email: data['email'] as String,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            phoneNumber: data['phoneNumber'] as String,
            dob: data['dob'] as String,
            joinDate: data['joinDate'] as String,
            role: 'member',
            branchLocation: data["branchLocation"] as String,
          );
        }
      }

      print("User document does not exist.");
      return null; // Return null if the document doesn't exist
    } catch (e) {
      print("Failed to fetch user data: $e");
      return null; // Return null in case of error
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
      print("User data updated successfully!");
    } catch (e) {
      print("Failed to update user data: $e");
    }
  }

  Future<void> createProduct(ProductModel product) async {
    try {
      // Reference to the products collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Save product data to Firestore
      await firestore.collection('products').doc(product.uid).set(product.toMap());
      print("Product added successfully!");
    } catch (e) {
      print("Failed to add product: $e");
    }
  }

  //do not invoke this function
  Future<void> addAllProducts(List<ProductModel> products) async {
    try {
      for (var product in products) {
        await createProduct(product); 
      }
     
    } catch (e) {
      print("Failed to add all products: $e");
    }
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) { 
      return; // Error fetching user
    } 

    final userCartRef = FirebaseFirestore.instance.collection('carts').doc(currentUser.uid);

    try {
      // Get the current cart data
      DocumentSnapshot snapshot = await userCartRef.get();
      if (snapshot.exists) {
        // If the cart already exists, add the new item to the cart
        List<dynamic> cartItems = snapshot['items'] ?? [];
        cartItems.add(cartItem.toMap());
        await userCartRef.update({'items': cartItems});
      } else {
        // If the cart doesn't exist, create a new cart with the item
        await userCartRef.set({
          'items': [cartItem.toMap()],
        });
      }
      print("Item added to cart");
    } catch (e) {
      print("Failed to add item to cart: $e");
    }
  }

  Future<void> deleteCartItem(String cartItemId) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Reference to the current user's cart
    final cartDocRef = FirebaseFirestore.instance.collection('carts').doc(currentUser.uid);

    // Fetch the current cart document
    final snapshot = await cartDocRef.get();

    if (!snapshot.exists) {
      print("Cart document does not exist.");
      return;
    }

    // Get the items array
    List<dynamic> items = snapshot.data()?['items'] ?? [];

    // Find and remove the item by itemId
    items.removeWhere((item) => item['itemId'] == cartItemId);

    // Update the document with the modified array
    await cartDocRef.update({
      'items': items,
    });

    print("Cart item deleted successfully.");
  } catch (e) {
    print("Error deleting cart item: $e");
  }
}


  Future<List<CartItemModel>> getCartItems() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("User not authenticated");
      return []; 
    }

    try {
      final userCartRef = FirebaseFirestore.instance.collection('carts').doc(currentUser.uid);
      DocumentSnapshot snapshot = await userCartRef.get();

      if (snapshot.exists) {
        // Print the raw data to check
        print("Cart exists: ${snapshot.data()}");

        List<dynamic> cartItems = snapshot['items'] ?? [];
        return cartItems.map((itemData) {
          return CartItemModel(
            productId: "itemData['productId']",
            itemId: itemData['itemId'],
            name: itemData['name'],
            price: 0.00 + itemData['price'],
            quantity: itemData['quantity'],
            addons: List<Map<String, dynamic>>.from(itemData['addons'] ?? []),
            instruction: itemData['instruction']??"",
            imageUrl: itemData['imageUrl'], 
          );
        }).toList();
      } else {
        print("No cart found for user");
        return []; 
      }
    } catch (e) {
      print("Failed to get cart items: $e");
      return []; 
    }
  }

}