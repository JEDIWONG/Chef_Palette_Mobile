class ProductModel {
  String uid;
  String name;
  String desc;
  double price;
  String imgUrl;
  List<Map<String, dynamic>> addons; // List of add-ons with names and prices

  ProductModel({
    required this.uid,
    required this.name,
    required this.desc,
    required this.price,
    required this.imgUrl,
    required this.addons,
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
