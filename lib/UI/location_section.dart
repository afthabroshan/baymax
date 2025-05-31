import 'package:baymax/Cubits/cubit/location_cubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/UI/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as Fmap;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class Location_Section extends StatelessWidget {
  const Location_Section({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: state is LocationLoading
              ? const Center(child: CustomLinearProgressIndicator())
              : state is DistanceCalculated
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...state.distances.map((userDistance) {
                            final displayName = (userDistance['display_name'] ??
                                'Unknown User');
                            final capitalizedFirstName =
                                displayName.split(' ').first[0].toUpperCase() +
                                    displayName.split(' ').first.substring(1);
                            final displayPic =
                                (userDistance['photo_url'] ?? '');

                            return GestureDetector(
                              onTap: () {
                                final userLatLng =
                                    userDistance['location'] as LatLng;
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: AppColors.ash,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.r)),
                                  ),
                                  builder: (context) => UserLocationBottomSheet(
                                      name: capitalizedFirstName,
                                      position: userLatLng,
                                      pic: displayPic),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 12.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                color: AppColors.ash,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      userDistance['photo_url'] != null
                                          ? CircleAvatar(
                                              radius: 12.sp,
                                              backgroundImage: NetworkImage(
                                                  userDistance['photo_url']),
                                              backgroundColor:
                                                  AppColors.textash,
                                            )
                                          : Icon(Icons.person,
                                              color: AppColors.blue,
                                              size: 16.sp),
                                      SizedBox(width: 5.w),
                                      Text(
                                        capitalizedFirstName,
                                        style: AppTextStyles.medContent
                                            .copyWith(color: AppColors.white),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${(userDistance['distance']).toStringAsFixed(0)} km away',
                                        style: AppTextStyles.medContent,
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(
                                        Icons.chevron_right_sharp,
                                        color: AppColors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    )
                  : state is LocationError
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Thannod location on aakan paranhathalle!",
                              style: AppTextStyles.medContent
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
        );
      },
    );
  }
}
