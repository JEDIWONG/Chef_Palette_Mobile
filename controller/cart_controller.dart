import 'package:chef_palette/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController{

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
        throw Exception("No user is currently signed in.");
      }

      // Reference to the current user's cart
      final cartRef = FirebaseFirestore.instance
          .collection('cart')
          .doc(currentUser.uid)
          .collection('items');

      // Delete the specific cart item
      await cartRef.doc(cartItemId).delete();

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
            productId: itemData['productId'],
            itemId: itemData['itemId'],
            name: itemData['name'],
            price: itemData['price'],
            quantity: itemData['quantity'],
            addons: List<Map<String, dynamic>>.from(itemData['addons'] ?? []),
            instruction: itemData['instruction'],
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