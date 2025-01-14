import 'package:chef_palette/component/product_card.dart';
import 'package:chef_palette/screen/notification.dart';
import 'package:chef_palette/screen/reservation.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/models/product_model.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final List<String> categories = [
    "All",
    "main",
    "side",
    "beverage",
  ];

  final List<String> categoryIcon = [
    "assets/icons/cat_0.png",
    "assets/icons/cat_1.png",
    "assets/icons/cat_2.png",
    "assets/icons/cat_3.png",
  ];

  String selectedCategory = "All";
  String selectedIcon = "assets/icons/cat_0.png";

  List<ProductModel> products = []; // Product list
  List<ProductModel> filteredProducts = []; // Filtered product list
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when screen is initialized
    searchController.addListener(_filterProducts); // Listen to search input
  }

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      List<ProductModel> fetchedProducts = [];
      for (var doc in snapshot.docs) {
        fetchedProducts.add(ProductModel.fromMap(doc.data()));
      }
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts; // Initialize with all products
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Filter products based on search query
  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Filter products based on selected category
    List<ProductModel> finalFilteredProducts = selectedCategory == "All"
        ? filteredProducts
        : filteredProducts.where((product) => product.category == selectedCategory).toList();

    finalFilteredProducts.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            floating: true,
            toolbarHeight: 80,
            elevation: 3.0,
            shadowColor: Colors.black,
            backgroundColor: CustomStyle.primary,
            title: const Text(
              "Good Day",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              
              preferredSize: Size(MediaQuery.sizeOf(context).width, 50),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.08,
                  vertical: 10,
                ),
                child: TextField(
                  
                  controller: searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(userId: userId),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.amber,
                    elevation: 3.0,
                  ),
                  icon: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _SliverHeaderDelegate(
              height: 50,
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Reservation()));
                  },
                  child: Text("Reservation", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _SliverHeaderDelegate(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0.5),
                      blurRadius: 0,
                      blurStyle: BlurStyle.outer,
                    )
                  ]
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final catIcon = categoryIcon[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          selectedIcon = catIcon;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                catIcon,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              category,
                              style: TextStyle(
                                color: selectedCategory == category
                                    ? CustomStyle.primary
                                    : Colors.black,
                                fontWeight: selectedCategory == category
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              height: 100,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 2 / 1.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = finalFilteredProducts[index];
                  return ProductCard(
                    obj: product,
                    imgUrl: product.imgUrl,
                    name: product.name,
                    price: product.price,
                  );
                },
                childCount: finalFilteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
