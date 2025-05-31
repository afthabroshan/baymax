import 'dart:developer';
import 'dart:ui';

import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemoryView extends StatefulWidget {
  final DateTime selectedDate;

  MemoryView({super.key, required this.selectedDate});

  @override
  State<MemoryView> createState() => _MemoryViewState();
}

class _MemoryViewState extends State<MemoryView> {
  List<Map<String, dynamic>> views = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getmemory();
  }

  Future<void> getmemory() async {
    try {
      final SupabaseClient supabase = Supabase.instance.client;
      final response = await supabase
          .from('calendar')
          .select('summary, media_urls')
          .eq('date_cal', widget.selectedDate);
      log("response from get memory $response");
      setState(() {
        views = List<Map<String, dynamic>>.from(response);
        isLoading = false;
        log("this is the views $views");
      });
    } catch (e) {
      log("these are the error for memory view $e");
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
          child: Container(
            color: Colors.black.withAlpha(50), // Optional dark overlay
          ),
        ),
        Center(
          child: Dialog(
            backgroundColor:
                const Color.fromARGB(255, 91, 91, 91).withAlpha(100),
            // elevation: 5,
            // shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'This is your memory for ${DateFormat.yMd().format(widget.selectedDate)}',
                        style: AppTextStyles.smallContent
                            .copyWith(color: AppColors.blue)),
                    SizedBox(height: 20.h),
                    if (isLoading)
                      const Center(
                        child: CustomCircularProgressIndicator(),
                      )
                    else if (views.isEmpty)
                      Center(
                        child: Text(
                          "No memories found.",
                          style: AppTextStyles.smallContent
                              .copyWith(color: AppColors.blue),
                        ),
                      )
                    else
                      Column(
                        children: views.map((memory) {
                          final text =
                              memory['summary'] as String? ?? "No summary";
                          log("this is the text form 91 $text");
                          final mediaUrl =
                              memory['media_urls'] as String? ?? "";
                          log("this is the url from 94 $mediaUrl");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (mediaUrl.isNotEmpty)
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // Rounded corners
                                    child: Image.network(
                                      mediaUrl,
                                      fit: BoxFit.cover,
                                      width: 150.w,
                                      height: 150.h,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 20.h),
                              Text(
                                text,
                                style: AppTextStyles.medContent
                                    .copyWith(color: AppColors.white),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        }).toList(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                AppColors.blue), // Set button background color
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 10.0.h,
                                    horizontal: 10.0.w)), // Add some padding
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Rounded corners
                            )),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Go back",
                              style: AppTextStyles.smallContent
                                  .copyWith(color: AppColors.bgcolor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
