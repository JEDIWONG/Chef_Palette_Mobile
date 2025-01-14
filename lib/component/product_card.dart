import 'package:chef_palette/models/product_model.dart';
import 'package:chef_palette/screen/product_details.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.price,
    required this.obj,
  });

  final ProductModel obj;
  final String imgUrl;
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              name: name,
              imgUrl: imgUrl,  // Pass the image URL directly
              price: price,
              desc: obj.desc,
              addons: obj.addons,
              option: obj.options,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<String>(
              future: getImageUrlFromFirebase(imgUrl),  // Fetch the image URL from Firebase
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();  // Show loading while fetching URL
                } else if (snapshot.hasError) {
                  return Text('Error loading image');
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      snapshot.data!,  // Use the fetched URL here
                      fit: BoxFit.fill,
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: 200,
                    ),
                  );
                } else {
                  return Text('No image available');
                }
              },
            ),
            ListTile(
              title: Text(
                name,
                style: CustomStyle.h2,
              ),
              subtitle: Text(
                "RM ${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
