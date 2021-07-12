import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField(this.handler);

  final Function? handler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Text('Enter Book Description'),
        ),
        SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          minLines: 10,
          maxLines: 10,
          onSaved: (String? value) => handler!(value),
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Description must not be empty';
            } else if (value.length < 50) {
              return 'Description should be at least 50 characters';
            }

            return null;
          },
        ),
      ],
    );
  }
}
