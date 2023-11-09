import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutBuilding extends StatelessWidget {
  final bool isPrice;
  final bool isRoom;
  final bool isBath;
  final TextEditingController controller;
  final String name;
  const AboutBuilding(
      {super.key,
      required this.name,
      required this.controller,
      this.isPrice = false,
      this.isBath = false,
      this.isRoom = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 70.sp,
          height: 50.sp,
          child: TextField(
            controller: controller,
            maxLength: isPrice
                ? 7
                : isRoom
                    ? 2
                    : isBath
                        ? 1
                        : 5,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
            ],
            decoration: const InputDecoration(counterText: ''),
          ),
        ),
      ],
    );
  }
}
