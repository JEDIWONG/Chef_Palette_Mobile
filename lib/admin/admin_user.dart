import 'package:chef_palette/admin/component/member_card.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await _firestoreService.fetchAllUsers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Members",
          style: CustomStyle.h3,
        ),
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
                        memberId: user.uid,
                        joinDate: user.joinDate,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}