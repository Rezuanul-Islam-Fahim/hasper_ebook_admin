import 'package:flutter/material.dart';

class SelectCoverPhoto extends StatelessWidget {
  const SelectCoverPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text('No Image Selected', textAlign: TextAlign.center),
            ),
          ),
        ),
        SizedBox(width: 60),
        TextButton.icon(
          icon: Icon(Icons.photo_rounded),
          label: Text('Select Photo'),
          onPressed: () {},
        ),
      ],
    );
  }
}
