import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';



class AddressSelector extends StatelessWidget{
  const AddressSelector({super.key, required this.addr, required this.hour});

  final String addr; 
  final String hour;

//  void showBranchPopup() {
//     List<Map<String, dynamic>> branches = [];
//     String? selectedBranch;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Select a Branch"),
//           content: Container(
//             width: double.maxFinite,
//             child: branches.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: branches.length,
//                     itemBuilder: (context, index) {
//                       final branch = branches[index];
//                       return RadioListTile<String>(
//                         title: Text(branch['name']),
//                         value: branch['name'],
//                         groupValue: selectedBranch,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedBranch = value;
//                           });
//                             Navigator.of(context).pop(); // Close the dialog after selection
//                         },
//                       );
//                     },
//                   ),
//           ),
//         );
//       },
//     );
//  }

 
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_pin,color: Colors.red,),
      title: Text(addr,style: CustomStyle.h4,),
      subtitle: Row(
        children: [
          Text("Opening Hour:  $hour",style: CustomStyle.subtitle,),
          const SizedBox(width: 10,),
            GestureDetector(
            // onTap: showBranchPopup,
            child: Text("Change Location", style: CustomStyle.link),
            )
        ],
      )
    );
  }

  
}