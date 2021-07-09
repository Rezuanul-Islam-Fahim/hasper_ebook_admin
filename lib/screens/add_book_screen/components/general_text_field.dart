import 'package:flutter/material.dart';

class GeneralTextField extends StatelessWidget {
  const GeneralTextField({
    this.title,
    this.placeHolder,
    this.isNumbered = false,
  });

  final String? title;
  final String? placeHolder;
  final bool? isNumbered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Text(title!),
        ),
        SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: placeHolder,
            hintStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          keyboardType: isNumbered! ? TextInputType.number : TextInputType.text,
        ),
      ],
    );
  }
}
