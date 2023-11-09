import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileButtom extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function() onTap;
  const ProfileButtom(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(
        text,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20.sp,
      ),
    );
  }
}
