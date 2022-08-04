import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    //DropdownMenuItem(child: Text("IEEE"), value: "IEEE"),
    //DropdownMenuItem(child: Text("MACE"), value: "MACE"),
    //DropdownMenuItem(child: Text("IEDC"), value: "IEDC"),
    DropdownMenuItem(child: Text("KTU"), value: "KTU"),
    DropdownMenuItem(child: Text("IIT"), value: "IIT"),
    DropdownMenuItem(child: Text("NIT"), value: "NIT"),
    DropdownMenuItem(child: Text("Exclusive"), value: "Exclusive"),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> get dropdownItems2 {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Coding"), value: "Coding"),
    DropdownMenuItem(child: Text("Arts"), value: "Arts"),
    DropdownMenuItem(child: Text("Sports"), value: "Sports"),
  ];
  return menuItems;
}

class DropDownButtonCus extends StatefulWidget {
  String type;
  static String selectedValue = "KTU";
  static String selectedValue2 = "Coding";
  DropDownButtonCus({Key? key, required this.type}) : super(key: key);

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
        value: widget.type == "1"
            ? DropDownButtonCus.selectedValue
            : DropDownButtonCus.selectedValue2,
        onChanged: (String? newValue) {
          setState(() {
            widget.type == "1"
                ? DropDownButtonCus.selectedValue = newValue!
                : DropDownButtonCus.selectedValue2 = newValue!;
          });
        },
        items: widget.type == "1" ? dropdownItems : dropdownItems2);
  }
}
