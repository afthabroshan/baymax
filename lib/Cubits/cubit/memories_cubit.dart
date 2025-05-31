// import 'dart:io';
// import 'package:baymax/Cubits/cubit/memories_state.dart';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:supabase/supabase.dart';
// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';

// class MemoryCubit extends Cubit<MemoryState> {
//   final SupabaseClient supabase;
//   final ImagePicker imagePicker;

//   MemoryCubit({required this.supabase, required this.imagePicker})
//       : super(const MemoryState());

//   Future<void> fetchUsers() async {
//     try {
//       emit(state.copyWith(isLoading: true));
//       final response = await supabase.from('Users').select('display_name, uid');
//       if (response.isNotEmpty) {
//         emit(state.copyWith(
//             users: List<Map<String, dynamic>>.from(response),
//             isLoading: false));
//       } else {
//         emit(state.copyWith(users: [], isLoading: false));
//       }
//     } catch (e) {
//       emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
//     }
//   }

//   Future<void> pickImages() async {
//     try {
//       final List<XFile>? images =
//           await imagePicker.pickMultiImage(imageQuality: 40);
//       if (images != null) {
//         final paths = images.map((image) => image.path).toList();
//         emit(state.copyWith(imagePaths: paths));
//         await uploadImages(paths);
//       }
//     } catch (e) {
//       emit(state.copyWith(errorMessage: 'Error picking images: $e'));
//     }
//   }

//   Future<void> uploadImages(List<String> imagePaths) async {
//     try {
//       for (var imagePath in imagePaths) {
//         final file = File(imagePath);
//         final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//         final path = 'uploads/$fileName';
//         final response =
//             await supabase.storage.from('images').upload(path, file);
//         if (response.isEmpty) {
//           throw Exception('Error uploading image');
//         }
//       }
//     } catch (e) {
//       emit(state.copyWith(errorMessage: 'Error uploading files: $e'));
//     }
//   }

//   Future<void> saveCalendar(String summary) async {
//     final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
//     final fb.User? user = auth.currentUser;
//     final String? userId = user?.uid;
//     try {
//       final response = await supabase.from('calendar').insert({
//         'date_cal': DateTime.now().toIso8601String(),
//         'summary': summary,
//         'useruid': userId,
//       }).select();

//       if (response.isNotEmpty) {
//         final calendarId = response[0]['id'];
//         for (String userID in state.selectedUsers) {
//           await supabase.from('Cal_Assocaitation').insert({
//             'cal_id': calendarId,
//             'useruid': userID,
//           });
//         }
//       }
//       emit(state.copyWith(errorMessage: null)); // Clear any previous errors
//     } catch (e) {
//       emit(state.copyWith(errorMessage: 'Error saving calendar: $e'));
//     }
//   }

//   void updateSelectedUsers(List<String> selectedUsers) {
//     emit(state.copyWith(selectedUsers: selectedUsers));
//   }
// }

import 'dart:io';
import 'dart:developer'; // Import for logging
import 'package:baymax/Cubits/cubit/memories_state.dart';
import 'package:baymax/data/association.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase/supabase.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class MemoryCubit extends Cubit<MemoryState> {
  final SupabaseClient supabase;
  final ImagePicker imagePicker;
  final DateTime selectedDate;

  MemoryCubit(
      {required this.supabase,
      required this.imagePicker,
      required this.selectedDate})
      : super(const MemoryState());

  Future<void> fetchUsers() async {
    try {
      emit(state.copyWith(isLoading: true));
      log('Fetching users...');
      // final response = await supabase.from('Users').select('display_name, uid');
      final response = await supabase
          .from('Users')
          .select('display_name, uid')
          .not('uid', 'eq', 'Thisiseveryonedebug');
      if (response.isNotEmpty) {
        log('Users fetched successfully: ${response.length} users found.');
        emit(state.copyWith(
            users: List<Map<String, dynamic>>.from(response),
            isLoading: false));
      } else {
        log('No users found.');
        emit(state.copyWith(users: [], isLoading: false));
      }
    } catch (e) {
      log('Error fetching users: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> pickImages() async {
    try {
      log('Picking images...');
      final List<XFile>? images =
          await imagePicker.pickMultiImage(imageQuality: 40);
      if (images != null && images.isNotEmpty) {
        final paths = images.map((image) => image.path).toList();

        log('Images picked: ${paths.length} images selected.');
        emit(state.copyWith(imagePaths: paths));
        // await uploadImages(paths);
        // await uploadImageToSupabase(paths[0]);
      } else {
        log('No images selected.');
      }
    } catch (e) {
      log('Error picking images: $e');
      emit(state.copyWith(errorMessage: 'Error picking images: $e'));
    }
  }

// Future<void> pickAndUploadImage() async {
//   try {
//     final XFile? image = await imagePicker.pickImage(imageQuality: 40, source: ImageSource.gallery);

//     if (image != null) {
//       final imagePath = image.path;
//       emit(state.copyWith(imagePaths: [imagePath]));

//       final imageUrl = await uploadImageToSupabase(imagePath);
//       if (imageUrl != null) {
//           emit(state.copyWith(imageUrl: imageUrl)); // add imageUrl to state model
//       }
//     } else {
//       log('No image selected.');
//     }
//   } catch (e) {
//     log('Error picking image: $e');
//     emit(state.copyWith(errorMessage: 'Error picking image: $e'));
//   }
// }
  // Future<void> uploadImages(List<String> imagePaths) async {
  //   try {
  //     log('Uploading ${imagePaths.length} images...');
  //     for (var imagePath in imagePaths) {
  //       final file = File(imagePath);
  //       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //       final path = 'uploads/$fileName';
  //       log('Uploading image to $path...');
  //       final response =
  //           await supabase.storage.from('images').upload(path, file);
  //       if (response.isEmpty) {
  //         log('Error uploading image to $path');
  //         throw Exception('Error uploading image');
  //       }
  //       log('Image uploaded successfully: $path');
  //     }
  //   } catch (e) {
  //     log('Error uploading files: $e');
  //     emit(state.copyWith(errorMessage: 'Error uploading files: $e'));
  //   }
  // }
  // Future<String?> uploadImages(List<String> imagePaths) async {
  //   try {
  //     log('Uploading images...');
  //     if (imagePaths.isEmpty) return null;
  //     final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
  //     final userId = auth.currentUser?.uid ?? 'unknown_user';

  //     final file = File(imagePaths[0]); // only first image for now
  //     final storageRef = FirebaseStorage.instance.ref().child(
  //         'calendar_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

  //     final uploadTask = await storageRef.putFile(file);
  //     log('Upload task completed.');
  //     final downloadUrl = await uploadTask.ref.getDownloadURL();
  //     log("Image uploaded. URL: $downloadUrl");
  //     return downloadUrl;
  //   } catch (e) {
  //     log("Error uploading image: $e");
  //     emit(state.copyWith(errorMessage: 'Image upload failed'));
  //     return null;
  //   }
  // }

  // Future<String?> uploadImages(List<String> imagePaths) async {
  //   try {
  //     if (imagePaths.isEmpty) return null;

  //     final file = File(imagePaths[0]);
  //     if (!file.existsSync()) {
  //       log("File does not exist at path: ${imagePaths[0]}");
  //       return null;
  //     }

  //     final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
  //     final userId = auth.currentUser?.uid ?? 'unknown_user';

  //     final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final refPath = 'calendar_images/$userId/$fileName';

  //     final storageRef = FirebaseStorage.instance.ref().child(refPath);
  //     log("Uploading to Firebase path: $refPath");

  //     await storageRef.putFile(file);
  //     final downloadUrl = await storageRef.getDownloadURL();
  //     log("Successfully uploaded. URL: $downloadUrl");

  //     return downloadUrl;
  //   } catch (e) {
  //     log("Error uploading image: $e");
  //     return null;
  //   }
  // }
  // Future<void> uploadImagesToSupabase(List<String> imagePaths) async {

  //   for (final path in imagePaths) {
  //     final file = File(path);
  //     final fileName = path.split('/').last;
  //     final storagePath =
  //         'uploads/${DateTime.now().millisecondsSinceEpoch}_$fileName';

  //     try {
  //       final response =
  //           await supabase.storage.from('images').upload(storagePath, file);

  //       final publicUrl =
  //           supabase.storage.from('images').getPublicUrl(storagePath);

  //       print('✅ Uploaded $fileName');
  //       print('🌐 Public URL: $publicUrl');
  //     } catch (e) {
  //       print('❌ Error uploading $fileName: $e');
  //     }
  //   }
  // }
  Future<String?> uploadImageToSupabase(String imagePath) async {
    final file = File(imagePath);
    final fileName = imagePath.split('/').last;
    final storagePath =
        'uploads/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    try {
      final response =
          await supabase.storage.from('images').upload(storagePath, file);

      // Get the public URL
      final publicUrl =
          supabase.storage.from('images').getPublicUrl(storagePath);

      print('✅ Uploaded $fileName');
      print('🌐 Public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ Error uploading $fileName: $e');
      return null;
    }
  }

  Future<void> saveCalendar(String summary, {String? imageFile}) async {
    final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
    final fb.User? user = auth.currentUser;
    final String? userId = user?.uid;
    final selectedUserIDs = state.selectedUsers.isEmpty
        ? ['Thisiseveryonedebug']
        : state.selectedUsers;
    log('Attempting to save calendar with summary: $summary for userId: $userId on $selectedDate');
    try {
      emit(state.copyWith(isSaving: true));
      //       String? media_urls;
      // if (imageFile != null) {
      //   log('Uploading image to Firebase Storage...');
      //   media_urls = await uploadImageToFirebase(imageFile, userId!);
      //   log('Image uploaded successfully: $media_urls');
      // }
      final response = await supabase.from('calendar').insert({
        'date_cal': selectedDate.toIso8601String(),
        'summary': summary,
        'useruid': userId,
        'media_urls': imageFile,
      }).select();

      if (response.isNotEmpty) {
        final calendarId = response[0]['id'];
        log('Calendar event saved successfully with calendar ID: $calendarId');
        log("this is test of the users present users ${state.selectedUsers}");
        for (String userID in selectedUserIDs) {
          log('Associating calendar event with user: $userID');
          await supabase.from('Cal_Assocaitation').insert({
            'cal_id': calendarId,
            'useruid': userID,
          });
        }
        // await fetchDatesWithData();
        //this is where i tried getting the refreshing upon the save
      } else {
        log('No response from calendar insert.');
      }
      // emit(state.copyWith(errorMessage: null)); // Clear any previous errors
      emit(state.copyWith(isSaving: false, errorMessage: null));
    } catch (e) {
      log('Error saving calendar: $e');
      emit(state.copyWith(
          isSaving: false, errorMessage: 'Error saving calendar: $e'));
    }
  }

  void updateSelectedUsers(List<String> selectedUsers) {
    log('Updating selected users: ${selectedUsers.join(', ')}');
    emit(state.copyWith(selectedUsers: selectedUsers));
  }
}
