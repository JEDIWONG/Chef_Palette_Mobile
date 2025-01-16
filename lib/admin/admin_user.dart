import 'package:chef_palette/admin/component/member_card.dart';
import 'package:chef_palette/controller/user_controller.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}
class _AdminUserState extends State<AdminUser> {
  final UserController _userController = UserController();
  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await _userController.fetchUsers();
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading users: $e');
    }
  }

  // Define the _showDeleteDialog method here
  void _showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the delete method or perform the action to delete the user
                try {
                  await _userController.deleteUser(userId);
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {
                    users.removeWhere((user) => user.uid == userId); // Remove the user from the list
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error deleting user')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Members", style: CustomStyle.h3),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text('No members found'))
              : Column(
                  children: [
                    const SizedBox(height: 50),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return MemberCard(
                            username: user.firstName,
                            memberId: user.uid,
                            joinDate: user.joinDate,
                            onDelete: () => _showDeleteDialog(context, user.uid),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
