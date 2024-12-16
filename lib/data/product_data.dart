import 'package:chef_palette/models/product.model.dart';

final List<ProductModel> products = [
  ProductModel(
    uid: "1",
    name: "Nasi Lemak",
    desc: "Traditional Malaysian dish",
    price: 12.50,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      "Extra Sambal",
      "Fried Chicken",
      "Boiled Egg",
      "Peanuts",
    ],
  ),
  ProductModel(
    uid: "2",
    name: "Roti Canai",
    desc: "Popular Malaysian flatbread",
    price: 5.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      "Curry Sauce",
      "Dhal Gravy",
      "Sugar Topping",
    ],
  ),
  ProductModel(
    uid: "3",
    name: "Laksa",
    desc: "Spicy noodle soup",
    price: 15.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      "Extra Prawns",
      "Cockles",
      "Boiled Egg",
    ],
  ),
  ProductModel(
    uid: "4",
    name: "Char Kway Teow",
    desc: "Famous stir-fried noodle dish",
    price: 14.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      "Extra Prawns",
      "Extra Chili Paste",
      "Duck Egg",
    ],
  ),
];
