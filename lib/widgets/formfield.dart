import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFieldCus extends StatefulWidget {
  final name;
  final TextEditingController con;
  const FormFieldCus({Key? key, this.name, required this.con})
      : super(key: key);

  @override
  State<FormFieldCus> createState() => _FormFieldCusState();
}

class _FormFieldCusState extends State<FormFieldCus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Text(
              '${widget.name}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: widget.name == "Description" ? 100 : 50,
          child: Center(
            child: TextFormField(
              // onChanged: (value) {
              //   setState(() {
              //     widget.con.text = value;
              //   });
              // },
              controller: widget.con,
              obscureText: widget.name == "Password" ? true : false,
              // keyboardType: name == "Description"
              //     ? TextInputType.multiline
              //     : TextInputType.text,
              maxLines: widget.name == "Description" ? 5 : 1,
              // scrollPadding: EdgeInsets.all(0),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Enter Your ${widget.name}";
                }
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              //onSaved: (val) => _email = val!,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
