import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_market/main.dart';

import '../../services/constants/app_colors.dart';

class CommentTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function() funksiya;
  const CommentTextField(
      {super.key, required this.textEditingController, required this.funksiya});

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width,
        height: 90,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: hiveDb.isLight
                ? BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      offset: const Offset(-1, -1),
                      color: Colors.grey.withOpacity(.2),
                      blurStyle: BlurStyle.outer,
                    ),
                  ], borderRadius: const BorderRadius.all(Radius.circular(50)))
                : null,
            height: 60,
            child: Card(
              elevation: hiveDb.isLight ? 1 : 9,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: widget.textEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  hintText: 'Message'.tr(),
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  suffixIcon: IconButton(
                    splashRadius: 1,
                    onPressed: widget.funksiya,
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.ff016FFF,
                    ),
                  ),
                  filled: true,
                  fillColor: hiveDb.isLight
                      ? AppColors.ff000000.withOpacity(.5)
                      : AppColors.ffffffff,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
