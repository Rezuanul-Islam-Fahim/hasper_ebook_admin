import 'package:flutter/material.dart';

class BookBottomSheet extends StatelessWidget {
  const BookBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            offset: Offset(0, -1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text('Start Reading'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
