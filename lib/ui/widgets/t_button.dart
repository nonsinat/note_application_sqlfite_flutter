// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:note2_applicatoin_flutter/ui/theme.dart';

class TButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const TButton({
    Key? key,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: primaryClr,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
