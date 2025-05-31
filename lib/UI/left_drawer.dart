// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';

// class drawer extends StatelessWidget {
//   const drawer({
//     super.key,
//     required List<Map<String, dynamic>> users,
//     required bool isLoading,
//     required this.pic,
//   })  : _users = users,
//         _isLoading = isLoading;

//   final List<Map<String, dynamic>> _users;
//   final bool _isLoading;
//   final String? pic;

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(35)),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                     sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
//                 child: SizedBox(
//                   width: 200.w,
//                   height: _users.length * 75, // Optional dark overlay
//                 ),
//               ),
//             ),
//           ),
//           _isLoading
//               ? Center(
//                   child: Lottie.asset(
//                     'assets/wood.json',
//                   ),
//                 )
//               : Align(
//                   alignment: Alignment.centerLeft,
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: _users.length,
//                         itemBuilder: (context, index) {
//                           final appUser = _users[index];
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage:
//                                   NetworkImage(appUser['photo_url'] ?? pic!),
//                             ),
//                             title: Text(
//                               appUser['display_name'],
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           );
//                         }),
//                   ),
//                 )
//         ],
//         // )
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:baymax/Cubits/cubit/drawer_cubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class drawer extends StatelessWidget {
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(
      builder: (context, state) {
        final drawerWidth = 150.w;
        return Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(35.r)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
                  child: SizedBox(
                    width: 150.w,
                    height: state.users.length * 75.0, // Optional dark overlay
                  ),
                ),
              ),
            ),
            state.isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/wood.json',
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final appUser = state.users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(appUser['photo_url'] ?? "none"),
                            ),
                            title: Text(
                              (appUser['display_name'] ?? "Unknown User")
                                  .split(' ')
                                  .first,
                              style: AppTextStyles.medContent
                                  .copyWith(color: AppColors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              left: drawerWidth - 10, // Align to the right edge of the drawer
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24.sp,
                color: AppColors.blue,
              ),
            ),
          ],
        );
      },
    );
  }
}
