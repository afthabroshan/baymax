import 'package:baymax/Cubits/cubit/AuthCubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/data/firebaseuser.dart';
import 'package:baymax/widgets/name_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Name_section extends StatelessWidget {
  const Name_section({
    super.key,
    required this.firstName,
    required this.pic,
  });

  final String firstName;
  final String? pic;

  @override
  Widget build(BuildContext context) {
    Shader heyGradient = const LinearGradient(
      colors: [
        // light gray
        AppColors.textash,
        AppColors.white // blue-cyan
      ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    Shader linearGradient = const LinearGradient(
      colors: <Color>[
        AppColors.white,
        AppColors.blue,
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    final currentUser = CurrentUser();
    final String? photoUrl = currentUser.photoURL;
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.85,
        child: CustomPaint(
          painter: WavePainter(),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 14.h,
                  left: 10.w,
                  child: Text('Hey',
                      style: GoogleFonts.abhayaLibre(
                          fontSize: 54.sp,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                          // color: AppColors.textash)),
                          foreground: Paint()..shader = heyGradient)),
                  // color: const Color.fromARGB(244, 220, 220, 220))),
                ),
                Positioned(
                  top: 52.h,
                  left: 36.w,
                  child: Text(firstName,
                      style: GoogleFonts.greatVibes(
                          fontSize: 64.sp,
                          letterSpacing: 3,
                          // color: AppColors.blue)),
                          foreground: Paint()..shader = linearGradient)),
                  // color: const Color.fromARGB(255, 148, 187, 255))),
                ),
                Positioned(
                  right: 30.w,
                  top: 26.h,
                  child: GestureDetector(
                    onTap: () async {
                      final selected = await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(1000, 80, 10,
                            100), // Adjust to position near avatar
                        items: [
                          PopupMenuItem(
                            value: 'logout',
                            child: Text(
                              'Logout',
                              style: AppTextStyles.smallContent
                                  .copyWith(color: AppColors.bgcolor),
                            ),
                          ),
                        ],
                      );

                      if (selected == 'logout') {
                        // Call your logout function here
                        await context.read<AuthCubit>().signOut();
                        await CurrentUser().clearUserDetails();
                        // Navigate to sign in page, replacing current page stack
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }
                    },
                    child: CircleAvatar(
                        radius: 28.r,
                        backgroundImage: NetworkImage(photoUrl ?? "")
                        // NetworkImage(pic!),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
