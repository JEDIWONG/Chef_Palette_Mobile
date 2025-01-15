import 'package:chef_palette/component/news_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget{
  String userId = FirebaseAuth.instance.currentUser!.uid;
  
  NotificationScreen({required this.userId,Key? key}) : super(key: key);

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

  void _viewNotification(String notificationId, String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(notificationId: notificationId, message: message),
      ),
    );
  }
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
                return GestureDetector(
                  onTap: () => _viewNotification(notification['id'], notification['message']),
                child: ListTile(
                  title: Text(notification['message']),
                  subtitle: Text(
                    notification['timestamp'].toDate().toString(),
                  ),
                  trailing: notification['status'] == 'unread'
                      ? Icon(Icons.circle, color: Colors.red, size: 12)
                      : null,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final String notificationId;
  final String message;

  const NotificationDetailScreen({
    Key? key,
    required this.notificationId,
    required this.message,
  }) : super(key: key);


  Future<void> _markAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      debugPrint('Notification marked as read');
    } catch (e) {
      debugPrint('Failed to update notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mark the notification as read when the screen is built.
    _markAsRead(notificationId);

    return Scaffold(
      appBar: AppBar(title: const Text("Notification Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Message:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(message),
          ],
        ),
      ),
    );
  }
}


