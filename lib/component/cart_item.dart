import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CartItem extends StatelessWidget {
  final String itemId;
  final String imgUrl;  // This will now be the Firestorage path to the image
  final String title;
  final int quantity;
  final double price;
  final Function(String) onItemRemoved; // Callback to parent

  const CartItem({
    super.key,
    required this.itemId,
    required this.imgUrl,  // Firestorage path for image
    required this.title,
    required this.quantity,
    required this.price,
    required this.onItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(itemId),
      direction: Axis.horizontal,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async {
            FirestoreService firestoreService = FirestoreService();
            await firestoreService.deleteCartItem(itemId);
            onItemRemoved(itemId); // Notify parent widget
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) async {
              FirestoreService firestoreService = FirestoreService();
              await firestoreService.deleteCartItem(itemId);
              onItemRemoved(itemId); // Notify parent widget
            },
            backgroundColor: Colors.red,
            label: "Swipe Left To Delete",
            icon: Icons.remove_shopping_cart_rounded,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: InkWell(
          onTap: () {},
          splashColor: Colors.grey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 211, 211, 211),
                  blurRadius: 1,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      // Using Firestorage to load the image
                      child: FutureBuilder<String>(
                        future: _loadImageUrl(imgUrl),  // Function to load the image URL from Firestorage
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loading indicator
                          }
                          if (snapshot.hasError) {
                            return Icon(Icons.error); // Show error icon
                          }
                          if (snapshot.hasData) {
                            return Image.network(
                              snapshot.data!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          }
                          return Icon(Icons.image_not_supported); // Default image if not found
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: CustomStyle.h3,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Quantity: $quantity",
                              style: CustomStyle.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "RM ${price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to load the image URL from Firestorage
  Future<String> _loadImageUrl(String imgUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(imgUrl);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception("Error loading image: $e");
    }
  }
}
