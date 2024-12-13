import 'package:chef_palette/component/cart_item.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  
  List<bool> isSelected = [true, false, false]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Menu',
        ),
        title: Text(
          "Cart",
          style: CustomStyle.h1,
        ),
      ),
      
      body: SingleChildScrollView(
        
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index; 
                    }
                  });
                },
                borderRadius: BorderRadius.circular(20),
                textStyle: TextStyle(fontSize: 14),
                selectedColor: Colors.white,
                fillColor: Colors.green,
                color: Colors.black,
                borderWidth: 1,
                borderColor: Colors.green,
                selectedBorderColor: Colors.green,
                children:  const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
                    child: Text("Dine-In"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 0),
                    child: Text("PickUp"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 0),
                    child: Text("Delivery"),
                  ),
                ],
              ),
            ), 

            ListTile(
              leading: const Icon(Icons.location_pin,color: Colors.red,),
              title: Text("Nasi Lemak Bamboo (Samarahan)",style: CustomStyle.h4,),
              subtitle: Row(
                children: [
                  Text("Opening Hour: 7AM-8PM",style: CustomStyle.subtitle,),
                  const SizedBox(width: 10,),
                  Text("Change Location",style: CustomStyle.link,)
                ],
              )
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: const CartItem(imgUrl: "assets/images/placeholder.png", title: "Nasi Lemak Bamboo",quantity: 1,price: 12,),

            ),
            
            RectButton(bg: Colors.green, fg: Colors.white, text: "Pay Now", func: (){}, rad: 0),
             
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  String _getSelectedOption() {
    List<String> options = ["Option 1", "Option 2", "Option 3"];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        return options[i];
      }
    }
    return "None";
  }
}
