import 'package:chef_palette/models/product.model.dart';

final List<ProductModel> products = [
  ProductModel(
    uid: "1",
    name: "Nasi Lemak",
    desc: "Traditional Malaysian dish",
    price: 12.50,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      {"name": "Extra Sambal", "price": 2.00},
      {"name": "Fried Chicken", "price": 5.00},
      {"name": "Boiled Egg", "price": 1.50},
      {"name": "Peanuts", "price": 1.00},
    ],
  ),
  ProductModel(
    uid: "2",
    name: "Roti Canai",
    desc: "Popular Malaysian flatbread",
    price: 5.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      {"name": "Curry Sauce", "price": 1.50},
      {"name": "Dhal Gravy", "price": 1.00},
      {"name": "Sugar Topping", "price": 0.50},
    ],
  ),
  ProductModel(
    uid: "3",
    name: "Laksa",
    desc: "Spicy noodle soup",
    price: 15.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      {"name": "Extra Prawns", "price": 3.00},
      {"name": "Cockles", "price": 2.50},
      {"name": "Boiled Egg", "price": 1.50},
    ],
  ),
  ProductModel(
    uid: "4",
    name: "Char Kway Teow",
    desc: "Famous stir-fried noodle dish",
    price: 14.00,
    imgUrl: "assets/images/placeholder.png",
    addons: [
      {"name": "Extra Prawns", "price": 3.00},
      {"name": "Extra Chili Paste", "price": 1.50},
      {"name": "Duck Egg", "price": 2.00},
    ],
  ),
];
