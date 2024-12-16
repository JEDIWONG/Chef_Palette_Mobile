class ProductModel {
  String uid;
  String name;
  String desc;
  double price;
  String imgUrl;
  List<String> addons; // Add-ons as a list of strings

  ProductModel({
    required this.uid,
    required this.name,
    required this.desc,
    required this.price,
    required this.imgUrl,
    this.addons = const [], // Default to an empty list if no add-ons
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'desc': desc,
      'price': price,
      'imgUrl': imgUrl,
      'addons': addons,
    };
  }
}
