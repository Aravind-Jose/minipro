import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("USA"), value: "USA"),
    DropdownMenuItem(child: Text("Canada"), value: "Canada"),
    DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
    DropdownMenuItem(child: Text("England"), value: "England"),
  ];
  return menuItems;
}

class DropDownButtonCus extends StatefulWidget {
  static String selectedValue = "USA";
  DropDownButtonCus({Key? key}) : super(key: key);

  @override
  State<DropDownButtonCus> createState() => _DropDownButtonCusState();
}

class _DropDownButtonCusState extends State<DropDownButtonCus> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        //dropdownColor: Colors.blueAccent,
        value: DropDownButtonCus.selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            DropDownButtonCus.selectedValue = newValue!;
          });
        },
        items: dropdownItems);
  }
}
