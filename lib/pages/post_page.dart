import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';

import '../../models/post_model.dart';
import '../../services/firebase/auth_service.dart';
import '../../services/firebase/db_service.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  const CommentPage({super.key, required this.post});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  getSenderView(CustomClipper clipper, BuildContext context, String messenge,
          String time) =>
      ChatBubble(
        margin: EdgeInsets.only(bottom: 20.sp),
        clipper: clipper,
        alignment: Alignment.topRight,
        backGroundColor: hiveDb.isLight
            ? AppColors.ff000000.withOpacity(.7)
            : AppColors.ff016FFF,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                messenge,
                style: TextStyle(
                    color: AppColors.ffffffff,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.ffffffff,
                ),
              ),
            ],
          ),
        ),
      );

  getReceiverView(CustomClipper clipper, BuildContext context, String messenge,
          String userName, String time, String? imageUrl) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 20.sp,
            child: imageUrl == null
                ? Text(
                    widget.post.userName.substring(0, 1),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
          ),
          ChatBubble(
            clipper: clipper,
            backGroundColor: const Color(0xffE7E7ED),
            margin: const EdgeInsets.only(bottom: 20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    messenge,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: hiveDb.getListenable,
        builder: (context, mode, child) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 1.6.sp,
            child: ListView(
              padding: EdgeInsets.only(bottom: 50.sp, top: 10.sp),
              shrinkWrap: true,
              primary: true,
              children: [
                StreamBuilder(
                  stream: DBService.db
                      .ref(Folder.post)
                      .child(widget.post.id)
                      .onValue,
                  builder: (context, snapshot) {
                    Post current = snapshot.hasData
                        ? Post.fromJson(
                            jsonDecode(
                                    jsonEncode(snapshot.data!.snapshot.value))
                                as Map<String, Object?>,
                            isMe: AuthService.user.uid == widget.post.userId)
                        : widget.post;

                    widget.post.comments = current.comments;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: current.comments.length,
                      itemBuilder: (context, index) {
                        final msg = current.comments[index];

                        if (AuthService.user.uid == msg.userId) {
                          return getSenderView(
                            ChatBubbleClipper2(type: BubbleType.sendBubble),
                            context,
                            msg.message,
                            "${msg.writtenAt.hour}:${msg.writtenAt.minute}",
                          );
                        }

                        return getReceiverView(
                            ChatBubbleClipper2(type: BubbleType.receiverBubble),
                            context,
                            msg.message,
                            msg.username,
                            "${msg.writtenAt.hour}:${msg.writtenAt.minute}",
                            AuthService.user.photoURL);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
