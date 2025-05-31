import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as Fmap;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class UserLocationBottomSheet extends StatelessWidget {
  final String name;
  final LatLng position;
  final String pic;

  const UserLocationBottomSheet(
      {super.key,
      required this.name,
      required this.position,
      required this.pic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Text(
            name,
            style: AppTextStyles.medContent.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Fmap.FlutterMap(
                options: Fmap.MapOptions(
                  initialCenter: position,
                  initialZoom: 12.0,
                ),
                children: [
                  Fmap.TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  Fmap.MarkerLayer(
                    markers: [
                      Fmap.Marker(
                          width: 80.0.w,
                          height: 80.0.h,
                          point: position,
                          child: (pic.isNotEmpty)
                              ? CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(pic),
                                  backgroundColor: Colors.white,
                                )
                              : const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                )),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
