import 'dart:developer';
import 'dart:ui';
import 'package:baymax/widgets/image_uploader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemoryView extends StatefulWidget {
  final DateTime selectedDate;

  const MemoryView({super.key, required this.selectedDate});

  @override
  State<MemoryView> createState() => _MemoryViewState();
}

class _MemoryViewState extends State<MemoryView> {
  final TextEditingController textController = TextEditingController();
  // Map<String, dynamic>? existingData;

  // @override
  // void initState() {
  //   super.initState();
  //   checkForExistingData();
  // }

  // void checkForExistingData() async {
  //   final response = await Supabase.instance.client
  //       .from('calendar')
  //       .select()
  //       .eq('date_cal', widget.selectedDate.toIso8601String());

  //   if (response.isNotEmpty) {
  //     setState(() {
  //       existingData = response[0];
  //       log("Existing data: $existingData");
  //     });
  //   } else {
  //     log("There exists no data");
  //   }
  // }

  // void savecalendar() async {
  //   final response = await Supabase.instance.client.from('calendar').insert({
  //     'date_cal': widget.selectedDate.toIso8601String(),
  //     'summary': textController
  //         .text, // Assuming an empty list for media URLs for ssimplicity
  //   });

  //   if (response.error != null) {
  //     log('Error inserting data: ${response.error!.message}');
  //   } else {
  //     log('Data inserted successfully: ${response.data}');
  //     Navigator.pop(context);
  //   }
  // }

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
                      'Add your memories for ${DateFormat.yMd().format(widget.selectedDate)}',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          color: const Color.fromARGB(192, 68, 137, 255)),
                    ),
                    SizedBox(height: 20.h),
                    // if (existingData != null) ...[
                    //   Text("Summary: ${existingData!['summary']}"),
                    //   // Wrap( children: (existingData!['media_urls'] as List<dynamic>) .map((url) => Padding( padding: const EdgeInsets.all(8.0), child: Image.network(url, width: 100, height: 100), )) .toList(), ),
                    // ] else ...[
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Summary',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30.0.r), // Rounded corners
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 102, 102, 102),
                              width: 2.0),
                          // Border color and width
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(192, 104, 104, 104),
                              width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(192, 68, 137,
                                255)), // Set button background color
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            vertical: 15.0.h,
                            horizontal: 20.0.w)), // Add some padding
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0.r), // Rounded corners
                        )),
                      ),
                      onPressed: () {
                        // Your logic for image uploading goes here
                        const ImageUploaderWidget();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Make sure the button is just large enough for the content
                        children: [
                          const Icon(
                            Icons.file_upload, // Upload icon
                            color:
                                Color.fromARGB(255, 20, 20, 20), // Icon color
                          ),
                          SizedBox(
                              width: 10
                                  .w), // Add some space between the icon and text
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0.h, horizontal: 4.0.w),
                            child: Text(
                              'Select Images',
                              style: TextStyle(
                                color: const Color.fromARGB(
                                    255, 0, 0, 0), // Text color
                                fontSize: 11.sp, // Font size for text
                                fontStyle: FontStyle.normal, // Bold text
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // savecalendar();
                    //   },
                    //   child: Text("Save"),
                    // ),
                    // ],
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: const Color.fromARGB(
                                  255, 124, 124, 124), // Text color
                              fontSize: 11.sp, // Font size for text
                              fontStyle: FontStyle.normal, // Bold text
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                const Color.fromARGB(192, 68, 137,
                                    255)), // Set button background color
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 15.0.h,
                                    horizontal: 20.0.w)), // Add some padding
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Rounded corners
                            )),
                          ),
                          onPressed: () {
                            // savecalendar();
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // Text color
                              fontSize: 11.sp, // Font size for text
                              fontStyle: FontStyle.normal, // Bold text
                            ),
                          ),
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
