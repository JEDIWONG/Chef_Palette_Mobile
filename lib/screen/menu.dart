import 'package:chef_palette/component/product_card.dart';
import 'package:chef_palette/data/product_data.dart';
import 'package:chef_palette/screen/notification.dart';
import 'package:chef_palette/screen/reservation.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    
    final filteredProducts = selectedCategory == "All"
        ? products
        : products.where((product) => product.category == selectedCategory).toList(); 

    filteredProducts.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar with title and action buttons
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
                child: const SearchBar(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  leading: Icon(Icons.search_rounded),
                  hintText: "Search",
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
                        builder: (context) => const NotificationScreen(),
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
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Reservation()));
                  },
                  child: Text("Reservation",style: TextStyle(fontWeight: FontWeight.bold))
                ),
              )
              
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
                      blurStyle: BlurStyle.outer
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

          // Product Grid
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
                  final product = filteredProducts[index];
                  return ProductCard(
                    obj: product,
                    imgUrl: product.imgUrl,
                    name: product.name,
                    price: product.price,
                  );
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeader Delegate
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
