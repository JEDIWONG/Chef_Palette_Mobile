class ProductModel {
  String uid;
  String name;
  String desc;
  double price;
  String imgUrl;
  String category;
  List<Map<String, dynamic>> addons;
  bool isAvailable;
  int prepTime;
  double rating;
  List<String> tags;
  List<String> ingredients;
  List<String> options; // New attribute for optional selections (e.g., Hot/Cold)

  ProductModel({
    required this.uid,
    required this.name,
    required this.desc,
    required this.price,
    required this.imgUrl,
    required this.category,
    required this.addons,
    this.isAvailable = true,
    this.prepTime = 10,
    this.rating = 4.5,
    this.tags = const [],
    this.ingredients = const [],
    this.options = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'desc': desc,
      'price': price,
      'imgUrl': imgUrl,
      'category': category,
      'addons': addons.map((addon) => Map<String, dynamic>.from(addon)).toList(),
      'isAvailable': isAvailable,
      'prepTime': prepTime,
      'rating': rating,
      'tags': tags,
      'ingredients': ingredients,
      'options': options,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imgUrl: map['imgUrl'] ?? '',
      category: map['category'] ?? '',
      addons: List<Map<String, dynamic>>.from(map['addons'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
      prepTime: map['prepTime'] ?? 10,
      rating: map['rating']?.toDouble() ?? 4.5,
      tags: List<String>.from(map['tags'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      options: List<String>.from(map['options'] ?? []),
    );
  }
}
