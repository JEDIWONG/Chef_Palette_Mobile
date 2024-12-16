import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String joinDate;

  const AccountCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.5,
            spreadRadius: 0.1,
            blurStyle: BlurStyle.normal,
            offset: Offset(0, 0),
            color: Colors.grey,
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 70,
            ),
            title: Text(
              "$firstName $lastName",
              style: CustomStyle.h3,
            ),
            subtitle: Text(
              "Joined at $joinDate",
              style: CustomStyle.subtitle,
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
