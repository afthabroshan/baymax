import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/data/notesAssoc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
    subscribeToNoteInserts(); // Add this
  }

  @override
  void dispose() {
    Supabase.instance.client.removeAllChannels();
    super.dispose();
  }

  Future<void> loadNotes() async {
    final fetchedNotes = await fetchUserNotes(); // fetch from Supabase
    setState(() {
      notes = fetchedNotes;
      isLoading = false;
    });
  }

  void removeNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void subscribeToNoteInserts() {
    log("listening");
    Supabase.instance.client
        .channel('custom-insert-channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notes_ass', // ensure this is the correct table
          callback: (payload) async {
            debugPrint('Realtime Insert Received: ${payload.newRecord}');

            // Re-fetch notes
            final updatedNotes = await fetchUserNotes();
            setState(() {
              notes = updatedNotes;
            });
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CustomCircularProgressIndicator());
    }

    if (notes.isEmpty) {
      return const Center(child: Text('No notes found.'));
    }

    return Align(
      child: SizedBox(
        height: 180.h,
        width: 290.w,
        child: CardSwiper(
          cardsCount: notes.length,
          cardBuilder: (context, index, percentX, percentY) {
            final note = notes[index];
            final createdAt = DateTime.parse(note['created_at']);
            final formattedDate = intl.DateFormat('MMM d').format(createdAt);
            log("note: $note");
            return Card(
              color: AppColors.ash,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with from & time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'From: ${note['Users']['display_name'].split(" ").first}',
                            style: AppTextStyles.smallContent),
                        Text(
                          // 'Time: ${note['created_at'].toString().split("T").first}',
                          'Time: $formattedDate',
                          style: AppTextStyles.smallContent,
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.blue),

                    // Text with overflow handling
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final textSpan = TextSpan(
                              text: note['note'] ?? '',
                              style: AppTextStyles.medContent.copyWith(
                                  color: AppColors.white, fontSize: 16.sp));
                          final textPainter = TextPainter(
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            text: textSpan,
                          );
                          textPainter.layout(maxWidth: constraints.maxWidth);
                          final isOverflowing = textPainter.didExceedMaxLines;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                textSpan,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isOverflowing)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: AppColors.ash,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (_) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "From: ${note['Users']['display_name'].split(" ").first}",
                                                      style: AppTextStyles
                                                          .smallContent),
                                                  Text(
                                                      "Time: ${note['created_at'].toString().split("T").first}",
                                                      style: AppTextStyles
                                                          .smallContent),
                                                  const Divider(
                                                    color: AppColors.blue,
                                                  ),
                                                  Text(
                                                    note['note'] ?? '',
                                                    style: AppTextStyles
                                                        .medContent
                                                        .copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 20.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'View More',
                                      style: TextStyle(color: AppColors.blue),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
