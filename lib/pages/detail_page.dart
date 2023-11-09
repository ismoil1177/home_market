import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/main/main_bloc.dart';
import 'package:home_market/blocs/post/post_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/models/facilities_model.dart';
import 'package:home_market/models/post_model.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_str.dart';
import 'package:home_market/services/constants/data.dart';
import 'package:home_market/services/firebase/store_service.dart';
import 'package:home_market/views/detail_txt.dart';
import 'package:home_market/views/facilities_view.dart';
import 'package:home_market/views/information_view.dart';
import 'package:home_market/views/loading/loading.dart';
import 'package:image_picker/image_picker.dart';

import 'map/add_map.dart';

class DetailPage extends StatefulWidget {
  final Post? post;

  const DetailPage({this.post, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<Facilities> facilities;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController phoneCtrl;
  late final TextEditingController areaController;
  late final TextEditingController roomsController;
  late final TextEditingController priceController;
  late final TextEditingController bathRoomsController;
  late bool isApartment;
  final ImagePicker picker = ImagePicker();

  List<File?> files = [];
  List<String>? images;
  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    if (widget.post != null) {
      images = widget.post!.gridImages;
      facilities = widget.post!.facilities;
      isApartment = widget.post!.isApartment;
      context.read<PostBloc>().add(PostIsApartmentEvent(isApartment));
      priceController =
          TextEditingController(text: widget.post!.price.replaceAll(',', ''));
      phoneCtrl = TextEditingController(text: widget.post!.phone);
      titleController = TextEditingController(text: widget.post!.title);
      contentController = TextEditingController(text: widget.post!.content);
      areaController =
          TextEditingController(text: widget.post!.area.replaceAll(',', ''));
      roomsController = TextEditingController(text: widget.post!.rooms);
      bathRoomsController = TextEditingController(text: widget.post!.bathrooms);
    } else {
      LatLong.lat = null;
      LatLong.long = null;
      facilities = [];
      isApartment = false;
      priceController = TextEditingController();
      titleController = TextEditingController();
      contentController = TextEditingController();
      areaController = TextEditingController();
      roomsController = TextEditingController();
      bathRoomsController = TextEditingController();
      phoneCtrl = TextEditingController();
    }
  }

  void getMultiImage() async {
    final xFile = await picker.pickMultiImage(maxHeight: 1000, maxWidth: 1000);
    files = xFile.map((e) => File(e.path)).toList();
    if (files.isNotEmpty && mounted) {
      context.read<PostBloc>().add(ViewGridImagesPostEvent(files));
    }

    if (images != null) {
      StoreService.removeFiles(images!);
    }
    images = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.post == null ? 'Create Announcement' : 'Update Announcement')
              .tr(),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              letterSpacing: 1.3.sp,
              fontFamily: I18N.poppins),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is CreatePostSuccess || state is UpdatePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully completed!!!")));
            context.read<MainBloc>().add(const GetAllDataEvent());
            Navigator.of(context).pop();
          }
          if (state is PostIsApartmentState) {
            isApartment = state.isApartment;
          }
        },
        child: ValueListenableBuilder(
            valueListenable: hiveDb.getListenable,
            builder: (context, mode, child) {
              return SafeArea(
                child:
                    BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tick if it is an Apartment'.tr(),
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: I18N.inter),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1.2.sp,
                                    child:
                                        BlocSelector<PostBloc, PostState, bool>(
                                      selector: (state) {
                                        if (state is PostIsApartmentState) {
                                          return state.isApartment;
                                        }

                                        return isApartment;
                                      },
                                      builder: (context, value) {
                                        return Checkbox.adaptive(
                                            value: value,
                                            onChanged: (value) {
                                              context.read<PostBloc>().add(
                                                  PostIsApartmentEvent(value!));
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.sp),
                              Text(
                                "Some Photos related to your Announcement".tr(),
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: I18N.poppins),
                              ),
                              SizedBox(height: 15.sp),
                              BlocBuilder<PostBloc, PostState>(
                                buildWhen: (previous, current) =>
                                    current is ViewGridImagesPostSuccess,
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: getMultiImage,
                                    child: files.isEmpty && images == null
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: 150.sp,
                                            width: 150.sp,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: !hiveDb.isLight
                                                  ? AppColors.ffffffff
                                                  : AppColors.ff000000
                                                      .withOpacity(.7),
                                              boxShadow: !hiveDb.isLight
                                                  ? [
                                                      BoxShadow(
                                                        blurRadius: 2.sp,
                                                        offset: Offset(
                                                            -2.sp, -2.sp),
                                                        color: AppColors
                                                            .ff016FFF
                                                            .withOpacity(
                                                                .08.sp),
                                                      ),
                                                      BoxShadow(
                                                        blurRadius: 4.sp,
                                                        offset:
                                                            Offset(3.sp, 3.sp),
                                                        color: AppColors
                                                            .ff016FFF
                                                            .withOpacity(
                                                                .12.sp),
                                                      ),
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        blurRadius: 2.sp,
                                                        offset: Offset(
                                                            -2.sp, -2.sp),
                                                        color: AppColors
                                                            .ffffffff
                                                            .withOpacity(
                                                                .08.sp),
                                                      ),
                                                      BoxShadow(
                                                        blurRadius: 4.sp,
                                                        offset:
                                                            Offset(3.sp, 3.sp),
                                                        color: AppColors
                                                            .ffffffff
                                                            .withOpacity(
                                                                .12.sp),
                                                      ),
                                                    ],
                                            ),
                                            child: Text(
                                              "Add Photos".tr(),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.ff016FFF,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 100.sp,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: images == null
                                                  ? files.length
                                                  : images!.length,
                                              itemBuilder: (context, i) {
                                                return Card(
                                                  child: images == null
                                                      ? Image.file(
                                                          files[i]!,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: images![i],
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator
                                                                  .adaptive(),
                                                        ),
                                                );
                                              },
                                            ),
                                          ),
                                  );
                                },
                              ),
                              SizedBox(height: 15.sp),
                              Text(
                                'Name of the building or Location'.tr(),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: I18N.poppins,
                                  color: AppColors.ff016FFF,
                                ),
                              ),
                              SizedBox(height: 10.sp),
                              CustomDetailTextField(
                                keyboardType: TextInputType.name,
                                controller: titleController,
                                title: "Title".tr(),
                                maxLines: 2,
                              ),
                              SizedBox(height: 10.sp),
                              GestureDetector(
                                onTap: () {
                                  log(LatLong.lat.toString());
                                  log(LatLong.long.toString());
                                },
                                child: Text(
                                  'Describe your House or Apartment'.tr(),
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: I18N.poppins,
                                      color: AppColors.ff016FFF),
                                ),
                              ),
                              SizedBox(height: 10.sp),
                              CustomDetailTextField(
                                keyboardType: TextInputType.name,
                                controller: contentController,
                                title: "Content".tr(),
                                maxLines: 10,
                              ),
                              SizedBox(height: 20.sp),
                              Text(
                                'Information about the building'.tr(),
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: I18N.inter),
                              ),
                              SizedBox(height: 20.sp),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AboutBuilding(
                                      name: "Area".tr(),
                                      controller: areaController),
                                  AboutBuilding(
                                    name: "Rooms".tr(),
                                    controller: roomsController,
                                    isRoom: true,
                                  ),
                                  AboutBuilding(
                                    name: "Bathrooms".tr(),
                                    controller: bathRoomsController,
                                    isBath: true,
                                  ),
                                  AboutBuilding(
                                    name: "Price".tr(),
                                    controller: priceController,
                                    isPrice: true,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.sp),
                              Text(
                                'Facilities'.tr(),
                                style: TextStyle(
                                    color: AppColors.ff016FFF,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: I18N.inter),
                              ),
                              Wrap(
                                children: [
                                  for (int i = 0; i < 8; i++)
                                    BlocBuilder<PostBloc, PostState>(
                                        builder: (context, state) {
                                      return FacilitiesContainer(
                                          facilities: facilities,
                                          facility: Facilities(
                                              icon: facilitiesIcons[i],
                                              name: facilitiesName[i]),
                                          onTap: () {
                                            final Facilities newFacility =
                                                Facilities(
                                                    icon: facilitiesIcons[i],
                                                    name: facilitiesName[i]);
                                            context.read<PostBloc>().add(
                                                FacilitiesPostEvent(
                                                    facilities: facilities,
                                                    facility: newFacility));
                                          });
                                    }),
                                ],
                              ),
                              SizedBox(height: 10.sp),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 20.sp, bottom: 20.sp),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddMap(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.ff016FFF,
                                        size: 25.sp,
                                      ),
                                      Text(
                                        "Choose location of your house".tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColors.ff016FFF,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: I18N.inter),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Phone Number'.tr(),
                                style: TextStyle(
                                    color: AppColors.ff016FFF,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: I18N.inter),
                              ),
                              SizedBox(height: 15.sp),
                              CustomDetailTextField(
                                keyboardType: TextInputType.datetime,
                                inputFormatter: true,
                                controller: phoneCtrl,
                                title: "Enter your Phone Number".tr(),
                                maxLines: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (titleController.text.isEmpty ||
                                      contentController.text.isEmpty ||
                                      areaController.text.isEmpty ||
                                      bathRoomsController.text.isEmpty ||
                                      phoneCtrl.text.isEmpty ||
                                      priceController.text.isEmpty ||
                                      roomsController.text.isEmpty ||
                                      (files.isEmpty && images == null)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: hiveDb.isLight
                                                ? AppColors.ff000000
                                                : AppColors.ffffffff,
                                            content: Text(
                                              'Plese fill all the field before pushing your Announcement'
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: I18N.inter,
                                                  color: hiveDb.isLight
                                                      ? AppColors.ffffffff
                                                      : AppColors.ff000000
                                                          .withOpacity(.7)),
                                            )));
                                    return;
                                  }
                                  if (LatLong.lat == null &&
                                      LatLong.long == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Xaritada manzil belgilanmagan!")));
                                    return;
                                  }
                                  String square = '';
                                  String price = '';
                                  int priceNum = 0;
                                  int squareNum = 0;

                                  for (var i = priceController.text.length - 1;
                                      i >= 0;
                                      i--) {
                                    if (i == 2 || i == 5) {
                                      if (priceController.text.length != 3) {
                                        price += ',';
                                      }
                                    }
                                    price += priceController.text[priceNum];
                                    if (priceNum <
                                        priceController.text.length - 1) {
                                      priceNum++;
                                    }
                                  }

                                  for (var i = areaController.text.length - 1;
                                      i >= 0;
                                      i--) {
                                    if (i == 2 || i == 5) {
                                      if (areaController.text.length != 3) {
                                        square += ',';
                                      }
                                    }
                                    square += areaController.text[squareNum];
                                    if (squareNum <
                                        areaController.text.length - 1) {
                                      squareNum++;
                                    }
                                  }
                                  if (square[0] == ',') {
                                    square = square.substring(1);
                                  }
                                  if (price[0] == ',') {
                                    price = price.substring(1);
                                  }

                                  if (widget.post == null) {
                                    context
                                        .read<PostBloc>()
                                        .add(CreatePostEvent(
                                          gridImages: files,
                                          title: titleController.text,
                                          content: contentController.text,
                                          facilities: facilities,
                                          area: square,
                                          bathrooms: bathRoomsController.text,
                                          isApartment: isApartment,
                                          phone: phoneCtrl.text,
                                          price: price,
                                          rooms: roomsController.text,
                                          lat: LatLong.lat.toString(),
                                          long: LatLong.long.toString(),
                                        ));
                                  } else {
                                    log("IMAGES = $images");
                                    context.read<PostBloc>().add(
                                          UpdatePostEvent(
                                            isLiked: widget.post!.isLiked,
                                            imagesUri: images,
                                            gridImages: files,
                                            postId: widget.post!.id,
                                            title: titleController.text,
                                            content: contentController.text,
                                            facilities: facilities,
                                            area: square,
                                            bathrooms: bathRoomsController.text,
                                            isApartment: isApartment,
                                            phone: phoneCtrl.text,
                                            price: price,
                                            rooms: roomsController.text,
                                            lat: widget.post!.lat,
                                            long: widget.post!.long,
                                          ),
                                        );
                                  }
                                },
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  alignment: Alignment.center,
                                  height: 60.sp,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 20.sp, bottom: 20.sp),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColors.ff016FFF.withOpacity(.3),
                                          AppColors.ff016FFF.withOpacity(.5),
                                          AppColors.ff016FFF.withOpacity(.8),
                                          AppColors.ff016FFF
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35.sp),
                                    ),
                                  ),
                                  child: Text(
                                    'Push Announcement',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: I18N.inter,
                                        color: hiveDb.isLight
                                            ? AppColors.ffffffff
                                            : AppColors.ff000000
                                                .withOpacity(.7)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (state is PostLoading) const PostLoadingPage()
                    ],
                  );
                }),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    phoneCtrl.dispose();
    areaController.dispose();
    roomsController.dispose();
    bathRoomsController.dispose();
    priceController.dispose();

    super.dispose();
  }
}
