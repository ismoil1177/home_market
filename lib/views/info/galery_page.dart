import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/models/post_model.dart';

// ignore: must_be_immutable
class GalleryPage extends StatefulWidget {
  Post? post;
  GalleryPage({required this.post, super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      child: GridView.builder(
          shrinkWrap: true,
          primary: true,
          itemCount: widget.post!.gridImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10.sp,
              crossAxisSpacing: 10.sp,
              crossAxisCount: 2),
          itemBuilder: (_, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(5.sp),
              child: CachedNetworkImage(
                placeholder: (context, url) => SizedBox(
                    height: 30.sp,
                    width: 30.sp,
                    child: const Center(
                        child: CircularProgressIndicator.adaptive())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: widget.post!.gridImages[i],
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  height: 50.sp,
                  width: 50.sp,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
    );
  }
}
