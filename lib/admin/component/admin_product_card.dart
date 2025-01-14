import 'package:chef_palette/style/style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminProductCard extends StatelessWidget {
  const AdminProductCard({
    super.key,
    required this.productID,
    required this.imgUrl,
    required this.name,
    required this.price,
  });

  final String productID;
  final String imgUrl; // Firebase Storage image path
  final String name;
  final double price;

  // Fetch image URL from Firebase Storage using the image path
  Future<String> getImageUrlFromFirebase(String imagePath) async {
    try {
      // Get reference to the image stored in Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching image URL from Firebase Storage: $e');
      return '';  // Return empty string if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Implement navigation logic
        // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNextScreen()));
      },
      child: ListTile(
        leading: FutureBuilder<String>(
          future: getImageUrlFromFirebase(imgUrl),  // Fetch the image URL from Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();  // Show loading while fetching URL
            } else if (snapshot.hasError) {
              return Icon(Icons.error);  // Show error icon if there's an issue
            } else if (snapshot.hasData && snapshot.data != null) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  snapshot.data!,  // Use the fetched URL here
                  fit: BoxFit.fill,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  height: 400,
                ),
              );
            } else {
              return Icon(Icons.broken_image);  // Show broken image icon if no URL
            }
          },
        ),
        title: Text(
          name,
          style: CustomStyle.h4,
        ),
        subtitle: Text(
          "RM ${price.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.green),
        ),
        trailing: Icon(Icons.navigate_next_rounded),
      ),
    );
  }
}
