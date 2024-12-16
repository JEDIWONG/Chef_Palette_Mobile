class CartItemModel {
  String productId;     
  String name;          
  String imageUrl;     
  List<Map<String, dynamic>> addons;
  double price;         
  int quantity;         
  double totalPrice;    
  String instruction;

  // Constructor with default values for addons and instruction
  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.addons,
    required this.instruction,
  }) : totalPrice = price * quantity;

  // Method to increase quantity and adjust total price
  void increaseQuantity() {
    quantity++;
    totalPrice = price * quantity;  
  }

  // Method to decrease quantity and adjust total price
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      totalPrice = price * quantity;  
    }
  }

  // Convert object to Map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'addons': addons.isEmpty ? [] : addons, // Ensure empty list for addons
      'instruction': instruction,
    };
  }

  // Create an object from a Map (Firestore document)
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      addons: List<Map<String, dynamic>>.from(map['addons'] ?? []), // Default empty list if null
      instruction: map['instruction'] ?? '',  // Default empty string if null
    );
  }
}
