import 'cart_item_model.dart'; // Import CartItemModel if it's in a separate file

class CartModel {
  String uid;  // Unique identifier for the user
  List<CartItemModel> items;  // List to store cart items

  CartModel({
    required this.uid,
    required this.items,
  });

  // Method to add an item to the cart
  void addItem(CartItemModel item) {
    // Check if the item already exists in the cart
    bool itemExists = items.any((existingItem) => existingItem.productId == item.productId);
    
    if (itemExists) {
      // If item exists, just update the quantity
      items.firstWhere((existingItem) => existingItem.productId == item.productId).increaseQuantity();
    } else {
      // If item doesn't exist, add it to the cart
      items.add(item);
    }
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.productId == productId);
  }

  void updateItemQuantity(String productId, int newQuantity) {
    if (newQuantity > 0) {
      CartItemModel item = items.firstWhere((item) => item.productId == productId);
      item.quantity = newQuantity;
      item.totalPrice = item.price * newQuantity;  // Update total price
    }
  }

  double getTotalPrice() {
    return items.fold(0, (total, item) => total + item.totalPrice);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      uid: map['uid'],
      items: List<CartItemModel>.from(map['items'].map((item) => CartItemModel.fromMap(item))),
    );
  }
}

