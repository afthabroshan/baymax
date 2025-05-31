// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';
// import 'package:baymax/UI/image_picker.dart';
// import 'package:baymax/data/firebaseuser.dart';
// import 'package:baymax/widgets/image_uploader_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:flutter/material.dart';
// import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';

// class Memoryadd extends StatefulWidget {
//   final DateTime selectedDate;

//   const Memoryadd({super.key, required this.selectedDate});

//   @override
//   State<Memoryadd> createState() => _MemoryViewState();
// }

// class _MemoryViewState extends State<Memoryadd> {
//   // final fb.User? currentUser = fb.FirebaseAuth.instance.currentUser;
//   final SupabaseClient supabase = Supabase.instance.client;
//   final TextEditingController textController = TextEditingController();
//   late String Association;
//   final MultiSelectController _controller = MultiSelectController();
//   List<Map<String, dynamic>> _users = [];
//   List<String> _selectedUsers = [];
//   List<String> dropdownItems = [];
//   bool _isLoading = true;
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? _images = [];
//   List<String> _imagepaths = [];
//   // Map<String, dynamic>? existingData;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }

//   Future<void> _pickImage() async {
//     try {
//       log("reached into image picker");
//       final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 40
//           // or ImageSource.camera
//           );
//       if (images != null) {
//         setState(() {
//           _images?.addAll(images);
//           _imagepaths = images.map((image) => image.path).toList();
//           _uploadpic();
//         });
//         log('Images selected: ${images.map((e) => e.path).join(", ")}');
//       } else {
//         log('No image selected');
//       }
//     } catch (e) {
//       log('Error picking image: $e');
//     }
//   }

//   Future _uploadpic() async {
//     try {
//       // Iterate over each image path in _imagePaths
//       for (var imagePath in _imagepaths) {
//         // Create a unique file name for each image based on the current timestamp
//         final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//         final paths = 'uploads/$fileName'; // Use a unique name for each file

//         // Convert the image path to a File object (assuming the paths are local file paths)
//         final File file = File(imagePath);

//         // Upload the image to Supabase storage
//         final response =
//             await Supabase.instance.client.storage.from('images').upload(
//                   paths,
//                   file,
//                 );

//         // Handle success or failure
//         if (response.isEmpty) {
//           log('Error uploading image: $response');
//         } else {
//           log('Image uploaded successfully: $paths');
//         }
//       }
//     } catch (e) {
//       log('Error uploading files: $e');
//     }
//   }

//   void savecalendar() async {
//     final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
//     final fb.User? user = auth.currentUser;
//     final String? userId = user?.uid;
//     log(userId.toString());
//     final currentUser = CurrentUser();
//     log("user id ${currentUser.uid}");
//     if (textController != null) {
//       final response = await Supabase.instance.client.from('calendar').insert({
//         'date_cal': widget.selectedDate.toIso8601String(),
//         'summary': textController.text,
//         'useruid': userId,
//         // Assuming an empty list for media URLs for ssimplicity
//       }).select();
//       if (response.isNotEmpty) {
//         final calendarId = response[0]['id'];
//         for (String userID in _selectedUsers) {
//           final associationResponse =
//               await Supabase.instance.client.from('Cal_Assocaitation').insert({
//             'cal_id': calendarId, // Foreign key from the 'calendar' table
//             'useruid': userID, // Associate the same user
//           });
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Event and associations saved successfully!")),
//         );
//       }
//     } else {
//       const SnackBar(content: Text("Fill either one of the fields"));
//     }
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       final response = await supabase.from('Users').select('display_name, uid');

//       if (response.isNotEmpty) {
//         setState(() {
//           _users = List<Map<String, dynamic>>.from(response);
//           _isLoading = false;
//         });
//         log("135 fetched users $_users");
//       } else {
//         setState(() {
//           // _users = [];
//           dropdownItems = [];
//           _isLoading = false;
//         });
//         log("no users found");
//       }
//     } catch (e) {
//       log('Error fetching users: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         BackdropFilter(
//           filter: ImageFilter.blur(
//               sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
//           child: Container(
//             color: Colors.black.withAlpha(50), // Optional dark overlay
//           ),
//         ),
//         Center(
//           child: Dialog(
//             backgroundColor:
//                 const Color.fromARGB(255, 91, 91, 91).withAlpha(100),
//             // elevation: 5,
//             // shadowColor: Colors.black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Add your memories for ${DateFormat.yMd().format(widget.selectedDate)}',
//                       style: TextStyle(
//                           fontSize: 13.sp,
//                           fontStyle: FontStyle.italic,
//                           color: const Color.fromARGB(192, 68, 137, 255)),
//                     ),
//                     SizedBox(height: 20.h),
//                     TextField(
//                       controller: textController,
//                       decoration: InputDecoration(
//                         labelText: 'Summary',
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(30.0.r), // Rounded corners
//                           borderSide: const BorderSide(
//                               color: Color.fromARGB(255, 102, 102, 102),
//                               width: 2.0),
//                           // Border color and width
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: const BorderSide(
//                               color: Color.fromARGB(192, 104, 104, 104),
//                               width: 2.0),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.h,
//                     ),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: WidgetStateProperty.all(
//                                 const Color.fromARGB(192, 68, 137,
//                                     255)), // Set button background color
//                             padding: WidgetStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     vertical: 15.0.h,
//                                     horizontal: 20.0.w)), // Add some padding
//                             shape:
//                                 WidgetStateProperty.all(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   30.0.r), // Rounded corners
//                             )),
//                           ),
//                           onPressed: () {
//                             // Your logic for image uploading goes here
//                             _pickImage();
//                           },
//                           child: Row(
//                             mainAxisSize: MainAxisSize
//                                 .min, // Make sure the button is just large enough for the content
//                             children: [
//                               const Icon(
//                                 Icons.file_upload, // Upload icon
//                                 color: Color.fromARGB(
//                                     255, 20, 20, 20), // Icon color
//                               ),
//                               SizedBox(
//                                   width: 10
//                                       .w), // Add some space between the icon and text
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 4.0.h, horizontal: 4.0.w),
//                                 child: Text(
//                                   'Select Images',
//                                   style: TextStyle(
//                                     color: const Color.fromARGB(
//                                         255, 0, 0, 0), // Text color
//                                     fontSize: 11.sp, // Font size for text
//                                     fontStyle: FontStyle.normal, // Bold text
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       ],
//                     ),
//                     SizedBox(height: 15.h),
//                     // Text("HI"),
//                     _users.isEmpty
//                         ? const Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         : MultiSelectContainer(
//                             controller: _controller,
//                             items: _users.map((user) {
//                               final displayName =
//                                   user['display_name'] as String;
//                               final uid = user['uid'] as String;
//                               log("295 $displayName");
//                               log("324 $uid");
//                               log("296 $_users");
//                               log('Number of users: ${_users.length}');

//                               return MultiSelectCard(
//                                 value: uid,
//                                 label: displayName,
//                                 decorations: MultiSelectItemDecorations(
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromARGB(
//                                         255, 144, 144, 144),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   selectedDecoration: BoxDecoration(
//                                     color:
//                                         const Color.fromARGB(192, 68, 137, 255),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChange: (allSelectedItems, selectedItem) {
//                               log("this is the allselected $allSelectedItems");
//                               log("this is the selected item $selectedItem");
//                               // Update selected users
//                               setState(() {
//                                 _selectedUsers = allSelectedItems
//                                     .map((e) => e.toString())
//                                     .toList();
//                               });
//                               log("Currently Selected: $_selectedUsers");
//                             },
//                           ),
//                     SizedBox(height: 20.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text(
//                             'Close',
//                             style: TextStyle(
//                               color: const Color.fromARGB(
//                                   255, 124, 124, 124), // Text color
//                               fontSize: 11.sp, // Font size for text
//                               fontStyle: FontStyle.normal, // Bold text
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: WidgetStateProperty.all(
//                                 const Color.fromARGB(192, 68, 137,
//                                     255)), // Set button background color
//                             padding: WidgetStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     vertical: 15.0.h,
//                                     horizontal: 20.0.w)), // Add some padding
//                             shape:
//                                 WidgetStateProperty.all(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   30.0), // Rounded corners
//                             )),
//                           ),
//                           onPressed: () {
//                             savecalendar();
//                           },
//                           child: Text(
//                             "Save",
//                             style: TextStyle(
//                               color: const Color.fromARGB(
//                                   255, 0, 0, 0), // Text color
//                               fontSize: 11.sp, // Font size for text
//                               fontStyle: FontStyle.normal, // Bold text
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'dart:ui';

import 'package:baymax/Cubits/cubit/calendar_cubit.dart';
import 'package:baymax/Cubits/cubit/memories_cubit.dart';
import 'package:baymax/Cubits/cubit/memories_state.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/data/association.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Memoryadd extends StatelessWidget {
  final DateTime selectedDate;

  Memoryadd({super.key, required this.selectedDate});
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<CalendarCubit>()),
        // BlocProvider.value(
        //   value: context.read<CalendarCubit>(),
        // ),
        BlocProvider(
          create: (_) => MemoryCubit(
            supabase: Supabase.instance.client,
            imagePicker: ImagePicker(),
            selectedDate: selectedDate,
          )..fetchUsers(),
        ),
      ],
      child: BlocBuilder<MemoryCubit, MemoryState>(
        builder: (context, state) {
          final hasSelectedImages =
              context.read<MemoryCubit>().state.imagePaths.isNotEmpty;
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
                child: Container(
                  color:
                      AppColors.bgcolor.withAlpha(50), // Optional dark overlay
                ),
              ),
              Center(
                child: Dialog(
                  backgroundColor: AppColors.textash.withAlpha(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Add your memories for //${DateFormat.yMd().format(selectedDate)}',
                              style: AppTextStyles.medContent
                                  .copyWith(color: AppColors.blue)),
                          SizedBox(height: 20.h),
                          TextField(
                            controller: textController,
                            style: AppTextStyles.medContent
                                .copyWith(color: Colors.white),
                            maxLines: null, // expands vertically
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Summary',
                              labelStyle: AppTextStyles.medContent
                                  .copyWith(color: AppColors.textash),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0.r),
                                borderSide: const BorderSide(
                                  color: AppColors.ash,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0.r),
                                borderSide: const BorderSide(
                                  color: AppColors.textash,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                hasSelectedImages
                                    ? AppColors.blue
                                    : AppColors.ash.withOpacity(0.2),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: hasSelectedImages
                                        ? AppColors.blue
                                        : AppColors.blue.withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 10.h),
                              ),
                              elevation: WidgetStateProperty.all(0),
                            ),
                            onPressed: () =>
                                context.read<MemoryCubit>().pickImages(),
                            child: Text(
                              hasSelectedImages ? 'Selected' : 'Select Images',
                              style: AppTextStyles.medContent.copyWith(
                                color: hasSelectedImages
                                    ? AppColors.white
                                    : AppColors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          state.isLoading
                              ? const CustomCircularProgressIndicator()
                              : MultiSelectContainer(
                                  controller: MultiSelectController(),
                                  items: state.users.map((user) {
                                    final displayName =
                                        user['display_name'] as String;
                                    final uid = user['uid'] as String;
                                    return MultiSelectCard(
                                      value: uid,
                                      label: displayName,
                                    );
                                  }).toList(),
                                  highlightColor:
                                      AppColors.blue.withOpacity(0.3),
                                  textStyles: MultiSelectTextStyles(
                                      disabledTextStyle:
                                          AppTextStyles.medContent,
                                      selectedTextStyle: AppTextStyles
                                          .medContent
                                          .copyWith(color: AppColors.white),
                                      textStyle: AppTextStyles.medContent),
                                  itemsDecoration: MultiSelectDecorations(
                                    selectedDecoration: BoxDecoration(
                                      color: AppColors.blue,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.ash.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                  ),
                                  onChange: (allSelectedItems, selectedItem) {
                                    // final selectedUids = allSelectedItems
                                    //     .map((e) => e.toString())
                                    //     .toList();

                                    // if (selectedUids.isEmpty) {
                                    //   selectedUids.add('Thisiseveryonedebug');
                                    // }

                                    // context
                                    //     .read<MemoryCubit>()
                                    //     .updateSelectedUsers(selectedUids);
                                    context
                                        .read<MemoryCubit>()
                                        .updateSelectedUsers(
                                          allSelectedItems
                                              .map((e) => e.toString())
                                              .toList(),
                                        );
                                  },
                                ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Close',
                                  style: AppTextStyles.smallContent,
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     final summary = textController.text;
                              //     log("this is the summary ");
                              //     final imagePaths = context
                              //         .read<MemoryCubit>()
                              //         .state
                              //         .imagePaths;

                              //     String? imageUrl;
                              //     if (imagePaths.isNotEmpty) {
                              //       imageUrl = await context
                              //           .read<MemoryCubit>()
                              //           .uploadImageToSupabase(imagePaths[0]);
                              //     }
                              //     context.read<MemoryCubit>().saveCalendar(
                              //         summary,
                              //         imageFile: imageUrl);

                              //     Navigator.of(context).pop();
                              //   },
                              //   child: const Text('Save'),
                              // ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(AppColors.blue),
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 10.0.h, horizontal: 10.0.w),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0.r),
                                    ),
                                  ),
                                ),
                                onPressed: context
                                        .read<MemoryCubit>()
                                        .state
                                        .isSaving
                                    ? null
                                    : () async {
                                        final summary = textController.text;
                                        log("this is the summary ");
                                        final imagePaths = context
                                            .read<MemoryCubit>()
                                            .state
                                            .imagePaths;

                                        String? imageUrl;
                                        if (imagePaths.isNotEmpty) {
                                          imageUrl = await context
                                              .read<MemoryCubit>()
                                              .uploadImageToSupabase(
                                                  imagePaths[0]);
                                        }

                                        await context
                                            .read<MemoryCubit>()
                                            .saveCalendar(summary,
                                                imageFile: imageUrl);
                                        // await fetchDatesWithData();
                                        // context
                                        //     .read<CalendarCubit>()
                                        //     .initialize();
                                        context
                                            .read<CalendarCubit>()
                                            .addDateWithData(
                                                selectedDate, imageUrl);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Memory saved successfully!'),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        // Only pop after save completes
                                        Navigator.of(context).pop();
                                      },
                                child:
                                    context.read<MemoryCubit>().state.isSaving
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text('Save',
                                            style: AppTextStyles.smallContent
                                                .copyWith(
                                                    color: AppColors.bgcolor)),
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
        },
      ),
    );
  }
}
