import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_market/services/constants/data.dart';

import '../../main.dart';
import '../../services/constants/app_colors.dart';
import '../../services/constants/app_str.dart';

class AddMap extends StatefulWidget {
  const AddMap({super.key});

  @override
  State<AddMap> createState() => _AddMapState();
}

class _AddMapState extends State<AddMap> {
  late GoogleMapController _completer;
  int i = 0;

  List<MapType> type = [
    MapType.hybrid,
    MapType.normal,
  ];

  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(41.311153, 69.279729),
    zoom: 10,
  );

  Marker? origin;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    log(position.toString());
    _cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addMap(LatLng pas) {
    LatLong.lat = pas.latitude;
    LatLong.long = pas.longitude;
    log(LatLong.long.toString());
    setState(() {
      origin = Marker(
        markerId: const MarkerId('1'),
        infoWindow: const InfoWindow(),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        position: LatLng(LatLong.lat!, LatLong.long!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xaritadan uyingizni belgilang'.tr(),
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              fontFamily: I18N.inter),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (i == 1) {
                i = 0;
              } else {
                i = 1;
              }
              setState(() {});
            },
            icon: Icon(
              Icons.map_rounded,
              color: hiveDb.isLight ? AppColors.ffffffff : AppColors.ff000000,
              size: 25.sp,
            ),
          )
        ],
      ),
      body: GoogleMap(
          mapType: type[i],
          initialCameraPosition: _cameraPosition,
          onMapCreated: (controller) => _completer = controller,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          onTap: (argument) {
            addMap(argument);
          },
          markers: origin != null ? {origin!} : {}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getLocation();
          _completer.animateCamera(
            CameraUpdate.newCameraPosition(_cameraPosition),
          );
        },
        child: const Icon(
          Icons.location_on_outlined,
        ),
      ),
    );
  }
}
