import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

class ImageUploaderWidget extends StatefulWidget {
  const ImageUploaderWidget({super.key});

  @override
  State<ImageUploaderWidget> createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  File? imageFile;
  Future pickimage() async{
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//  final result = await FilePicker.platform.pickFiles( type: FileType.image, ); if (result != null && result.files.single.path != null) { setState(() { imageFile = File(result.files.single.path!); });}
    // if (image != null){
    //   setState(() {
    //     imageFile = File(image.path);
    //   });
    // } 
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(child: Column(
      children: [
        imageFile != null ? Image.file(imageFile!) : const Text("no images selected"),
        ElevatedButton(onPressed: pickimage, child: Text("Upload Image"))
      ],
      
    ),);
  }
}