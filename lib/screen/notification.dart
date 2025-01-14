import 'package:chef_palette/component/news_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget{
  String userId = FirebaseAuth.instance.currentUser!.uid;

  NotificationScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

Future<List<Map<String, dynamic>>> fetchUserNotifications(String userId) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'message': data['message'],
        'timestamp': data['timestamp'],
        'status': data['status'],
      };
    }).toList();
  } catch (e) {
    debugPrint("Failed to fetch notifications for user $userId: $e");
    return [];
  }
}


Future<void> sendNotification(String userId, String message) async {
  try {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'unread', // Initially mark as unread
    });
    debugPrint("Notification sent to user $userId: $message");

  } catch (e) {
    debugPrint("Failed to send notification: $e");
  }
} 

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchUserNotifications(widget.userId);
    debugPrint("The id used here is: ${widget.userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load notifications"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No notifications"));
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['message']),
                  subtitle: Text(
                    notification['timestamp'].toDate().toString(),
                  ),
                  trailing: notification['status'] == 'unread'
                      ? Icon(Icons.circle, color: Colors.red, size: 12)
                      : null,
                );
              },
            );
          }
        },
      ),
    );
  }
}


