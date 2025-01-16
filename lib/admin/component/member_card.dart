import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget{
  const MemberCard({
    super.key, 
    required this.username,
    required this.memberId, 
    required this.joinDate,
    required this.onDelete,
    });

  final String username;
  final String memberId; 
  final String joinDate; 
  final VoidCallback onDelete;

 void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Text("Are you sure you want to delete the account for $username?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the delete action
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDeleteDialog(context), 
      child: Container(
          
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 0.5,
                color: Colors.green,
                blurRadius: 0.5,
                blurStyle: BlurStyle.normal,
              )
            ]
          ),
          child: ListTile(
            title: Text(
            "Username: $username",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
            subtitle: Text("Id: $memberId \nJoined $joinDate",
            style: const TextStyle(
              fontSize: 14,
              fontWeight:FontWeight.bold, 
              color: Colors.grey,
            ),),

            trailing: const Icon(Icons.navigate_next_rounded),
          )
        ),
    );
  }
  
}