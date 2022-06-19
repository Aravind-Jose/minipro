import 'package:flutter/material.dart';

class FormFieldCus extends StatefulWidget {
  final name;
  const FormFieldCus({Key? key, this.name}) : super(key: key);

  @override
  State<FormFieldCus> createState() => _FormFieldCusState();
}

class _FormFieldCusState extends State<FormFieldCus> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            '${widget.name}',
          ),
        ),
        Expanded(
          flex: 3,
          // child: Padding(
          //   // padding: EdgeInsets.symmetric(vertical: 13),
          child: Container(
            height: widget.name == "Description" ? 100 : 50,
            child: Center(
              child: TextFormField(
                obscureText: widget.name == "password" ? true : false,
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
          //),
        ),
      ],
    );
  }
}