import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function(void)? onPressed;
  final String? title;
  const CustomButton({Key? key, this.onPressed,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
            child: Center(child: Text(title ?? ''))));
  }
}
