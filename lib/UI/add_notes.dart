import 'dart:ui';

import 'package:baymax/Cubits/cubit/add_notes_cubit.dart';
import 'package:baymax/Cubits/cubit/add_notes_state.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotes extends StatelessWidget {
  const AddNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider(
            create: (_) => AddNoteCubit(),
            child: const AddnotesView(),
          ),
        );
      },
      icon: Image.asset(
        'assets/notes.png',
        width: 105.w,
        height: 115.h,
        // color: AppColors.blue, // optional if you want to color the image
      ),
    );
  }
}

class AddnotesView extends StatelessWidget {
  const AddnotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddNoteCubit>();
    final textController = TextEditingController();

    // Fetch users when dialog is shown
    cubit.fetchUsers();

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(color: AppColors.bgcolor.withAlpha(50)),
        ),
        Center(
          child: Dialog(
            backgroundColor: AppColors.ash.withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leave your Notes',
                        style: AppTextStyles.medContent
                            .copyWith(color: AppColors.blue)),
                    SizedBox(height: 20.h),
                    BlocBuilder<AddNoteCubit, AddNoteState>(
                      builder: (context, state) {
                        textController.value =
                            TextEditingValue(text: state.noteText);
                        return TextField(
                          controller: textController,
                          onChanged: cubit.updateNote,
                          style: AppTextStyles.medContent.copyWith(
                              color: Colors.white), // white font + custom style
                          maxLines: null, // expands vertically
                          minLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Note',
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
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    BlocBuilder<AddNoteCubit, AddNoteState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                              child: CustomCircularProgressIndicator());
                        }
                        return MultiSelectContainer(
                          controller: MultiSelectController(),
                          items: state.users.map((user) {
                            final displayName = user['display_name'] as String;
                            final uid = user['uid'] as String;
                            return MultiSelectCard(
                              value: uid,
                              label: displayName,
                            );
                          }).toList(),
                          highlightColor: AppColors.blue.withOpacity(0.3),
                          textStyles: MultiSelectTextStyles(
                              disabledTextStyle: AppTextStyles.medContent,
                              selectedTextStyle: AppTextStyles.medContent
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
                            context.read<AddNoteCubit>().updateSelectedUsers(
                                  allSelectedItems
                                      .map((e) => e.toString())
                                      .toList(),
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            cubit.clearNote();
                            Navigator.of(context).pop();
                          },
                          child:
                              Text('Close', style: AppTextStyles.smallContent),
                        ),
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
                                borderRadius: BorderRadius.circular(20.0.r),
                              ),
                            ),
                          ),
                          onPressed: () {
                            cubit.saveNote();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Save",
                            style: AppTextStyles.smallContent
                                .copyWith(color: AppColors.bgcolor),
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
