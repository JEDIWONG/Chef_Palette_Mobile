import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/controller/branch_controller.dart';
import 'package:chef_palette/controller/user_controller.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chef_palette/models/branch_model.dart';

class Branch extends StatefulWidget {
  const Branch({super.key, required this.onBranchChanged});

  final Function(String) onBranchChanged; // Callback function to handle branch name change

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  List<BranchModel> branches = [];
  String selectedBranch = "";
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    final branchController = BranchController();
    final fetchedBranches = await branchController.fetchBranches();
    setState(() {
      branches = fetchedBranches;
    });
  }

  Future<void> updateBranchLocation(String branchName) async {
    try {
      final userController = UserController();
      await userController.updateUserBranchLocation(uid, branchName);

      setState(() {
        selectedBranch = branchName;
      });

      // Invoke the callback to notify parent widget of the branch change
      widget.onBranchChanged(branchName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Branch updated to $branchName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update branch')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Back',
          first: false,
        ),
        title: Text(
          "Branchs",
          style: CustomStyle.h1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("Please Select A Branch : ", style: CustomStyle.h4,),
            ),
            Column(
              children: branches.map((branch) {
                return ListTile(
                  title: Text(branch.name),
                  trailing: selectedBranch == branch.name
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => updateBranchLocation(branch.name),
                );
              }).toList(),
            )
          ]
        ),
      ),
    );
  }
}