import 'package:chef_palette/component/news_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget{
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
  
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
          
          title: Text(
            "Notification",
            style: CustomStyle.h1,
          ),

          bottom: const TabBar(
              tabs: [
                Tab(text: "News"),
                Tab(text: "Chat"),
              ],
            ),
        ),

        body: const TabBarView(
          children: [
            NewsTabs(),
          ],
        ),

      )
    );
  }
}

class NewsTabs extends StatelessWidget{

  const NewsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return  const SingleChildScrollView(
      child: Column(
        children: [
          NewsCard(title: "Order is Ready", desc: "desc", date: "12-12-2024"),
          NewsCard(title: "Order is Ready", desc: "desc", date: "1-12-2024"),
        ],
      ),
    );
  }
  
}

