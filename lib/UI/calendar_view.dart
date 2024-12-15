import 'dart:developer';
import 'package:baymax/widgets/image_uploader_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarView extends StatefulWidget {
  final DateTime selectedDate;
  
  CalendarView({super.key, required this.selectedDate});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final TextEditingController textController = TextEditingController();
  Map<String, dynamic>? existingData;

  @override
  void initState() {
    super.initState();
    checkForExistingData();
  }

  void checkForExistingData() async {
    final response = await Supabase.instance.client
        .from('calendar')
        .select()
        .eq('date_cal', widget.selectedDate.toIso8601String());

    if (response.isNotEmpty) {
      setState(() {
        existingData = response[0];
        log("Existing data: $existingData");
      });
    } else {
      log("There exists no data");
    }
  }

  void savecalendar() async {
    final response = await Supabase.instance.client.from('calendar').insert({
      'date_cal': widget.selectedDate.toIso8601String(),
      'summary': textController.text, // Assuming an empty list for media URLs for ssimplicity
    });

    if (response.error != null) {
      log('Error inserting data: ${response.error!.message}');
    } else {
      log('Data inserted successfully: ${response.data}');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                'Selected Date: ${DateFormat.yMd().format(widget.selectedDate)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (existingData != null) ...[
                Text("Summary: ${existingData!['summary']}"),
                // Wrap( children: (existingData!['media_urls'] as List<dynamic>) .map((url) => Padding( padding: const EdgeInsets.all(8.0), child: Image.network(url, width: 100, height: 100), )) .toList(), ),
              ] else ...[
                TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: 'Summary'),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){const ImageUploaderWidget();}, child: Text("Upload")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    savecalendar();
                  },
                  child: Text("Save"),
                ),
              ],
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
