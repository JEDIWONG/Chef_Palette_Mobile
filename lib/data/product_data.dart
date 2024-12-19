// should be deleted after finish development

import 'package:chef_palette/models/product.model.dart';

final List<ProductModel> products = [
  ProductModel(
    uid: "1",
    name: "Nasi Lemak Ayam Goreng",
    desc: "A traditional Malaysian dish with fried chicken.",
    price: 12.50,
    imgUrl: "assets/images/placeholder.png",
    category: "main",
    addons: [
      {"name": "Extra Sambal", "price": 2.00},
      {"name": "Boiled Egg", "price": 1.50},
    ],
    options: ["none"],
    ingredients: ["Rice", "Sambal", "Anchovies", "Chicken"],
    tags: ["Best Seller"],
  ),
  ProductModel(
    uid: "2",
    name: "Mee Goreng Mamak",
    desc: "Spicy stir-fried noodles with vegetables and tofu.",
    price: 10.00,
    imgUrl: "assets/images/placeholder.png",
    category: "main",
    addons: [
      {"name": "Fried Egg", "price": 1.50},
      {"name": "Extra Tofu", "price": 1.00},
    ],
    options: ["none"],
    ingredients: ["Noodles", "Soy Sauce", "Chili Paste"],
    tags: ["Spicy"],
  ),
  ProductModel(
    uid: "3",
    name: "Roti Canai with Curry",
    desc: "Flaky flatbread served with a side of curry.",
    price: 5.00,
    imgUrl: "assets/images/placeholder.png",
    category: "main",
    addons: [
      {"name": "Extra Curry", "price": 2.00},
    ],
    options: ["none"],
    ingredients: ["Flour", "Curry", "Oil"],
  ),
  ProductModel(
    uid: "4",
    name: "Teh Tarik",
    desc: "A popular Malaysian pulled tea, served hot or cold.",
    price: 3.50,
    imgUrl: "assets/images/placeholder.png",
    category: "beverage",
    addons: [],
    options: ["Hot", "Cold"],
    ingredients: ["Black Tea", "Condensed Milk"],
    tags: ["Popular"],
  ),
  ProductModel(
    uid: "5",
    name: "Kopi O",
    desc: "Classic black coffee, served hot or cold.",
    price: 3.00,
    imgUrl: "assets/images/placeholder.png",
    category: "beverage",
    addons: [],
    options: ["Hot", "Cold"],
    ingredients: ["Coffee Beans", "Water"],
  ),
  ProductModel(
    uid: "6",
    name: "Iced Lemon Tea",
    desc: "Refreshing tea with a splash of lemon.",
    price: 4.50,
    imgUrl: "assets/images/placeholder.png",
    category: "beverage",
    addons: [],
    options: ["Cold"],
    ingredients: ["Tea", "Lemon", "Sugar"],
    tags: ["Refreshing"],
  ),
  ProductModel(
    uid: "7",
    name: "Cendol",
    desc: "Traditional dessert with shaved ice, coconut milk, and palm sugar.",
    price: 6.00,
    imgUrl: "assets/images/placeholder.png",
    category: "side",
    addons: [
      {"name": "Extra Gula Melaka", "price": 1.00},
    ],
    options: ["none"],
    ingredients: ["Coconut Milk", "Palm Sugar", "Green Jelly"],
    tags: ["Dessert"],
  ),
  ProductModel(
    uid: "8",
    name: "Sirap Bandung",
    desc: "Rose syrup drink mixed with condensed milk.",
    price: 4.00,
    imgUrl: "assets/images/placeholder.png",
    category: "beverage",
    addons: [],
    options: ["Cold"],
    ingredients: ["Rose Syrup", "Condensed Milk"],
  ),
  ProductModel(
    uid: "9",
    name: "Nasi Goreng Kampung",
    desc: "Village-style fried rice with anchovies and vegetables.",
    price: 11.00,
    imgUrl: "assets/images/placeholder.png",
    category: "main",
    addons: [
      {"name": "Fried Egg", "price": 1.50},
    ],
    options: ["none"],
    ingredients: ["Rice", "Anchovies", "Vegetables"],
  ),
  ProductModel(
    uid: "10",
    name: "Milo Dinosaur",
    desc: "Iced chocolate malt drink.",
    price: 4.00,
    imgUrl: "assets/images/placeholder.png",
    category: "beverage",
    addons: [],
    options: ["Hot","Cold"],
    ingredients: ["Milo Powder", "Ice", "Milk"],
  ),
];