import "package:chef_palette/component/custom_button.dart";
import "package:chef_palette/style/style.dart";
import "package:flutter/material.dart";

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:const CustomBackButton(title: "Menu", first: true),
          leadingWidth: MediaQuery.sizeOf(context).width*0.3,
          title: Text("Rewards", style: CustomStyle.h1),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Redeem"),
              Tab(text: "Earn"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(
              child: RewardsRedeem(),
            ),
            Center(
              child: Text(""), // You can replace with actual content for Earn tab
            ),
            Center(
              child: Text('History Content'), // You can replace with actual content for History tab
            ),
          ],
        ),
      ),
    );
  }
}

class RewardsRedeem extends StatelessWidget {
  const RewardsRedeem({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(  
      child: Column(
        children: [
          SizedBox(height: 50),
          Text(
            "You Have Collected",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.green,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            "1000",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            "Points",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 20),
          RedeemCard(title: "Free Nasi Lemak Pop", quantity: 1, score: 3000),
          RedeemCard(title: "Free Coffee", quantity: 1, score: 1000),
          RedeemCard(title: "Free Ice Cream", quantity: 1, score: 3000),
        ],
      ),
    );
  }
}


class RedeemCard extends StatelessWidget{
  const RedeemCard({super.key, required this.title, required this.quantity, required this.score});

  final String title;
  final int quantity; 
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      padding: const EdgeInsets.all(10),
      
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            blurStyle: BlurStyle.normal,
            color: Colors.grey,
            offset: Offset(1, 1),
          )
        ]
      ),
      
      child: Column(
        children: [
          ListTile(
            title: Text(title,style: CustomStyle.h4,),
            trailing: Text("x $quantity",style: CustomStyle.txt),
            subtitle: Text("$score points",style: CustomStyle.subtitle,),
          ),

          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(left: 150),
            child:  RectButton(bg: Colors.green, fg: Colors.black, text: "Redeem", func: (){}, rad: 10),
          )
         
          
        ],
      ),
    );
  }
  
}