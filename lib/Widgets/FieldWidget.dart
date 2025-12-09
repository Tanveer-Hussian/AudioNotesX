import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FieldWidget extends StatefulWidget {

   TextEditingController controller = TextEditingController();
   final String hintText; 
   final String? Function(String?) validator;
   final TextInputType keyBoardType;

   FieldWidget({required this.controller, required this.hintText, required this.validator, required this.keyBoardType});

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
       controller: widget.controller,
       keyboardType: widget.keyBoardType,
       decoration: InputDecoration(
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
         labelText: widget.hintText,
       ),
       validator: widget.validator,
    );
  }
}
