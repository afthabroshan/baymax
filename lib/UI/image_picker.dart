import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    try {
      log("reached into image picker");
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, // or ImageSource.camera
      );
      if (image != null) {
        setState(() {
          _image = image;
        });
        log('Image selected: ${image.path}');
      } else {
        log('No image selected');
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(192, 68, 137, 255), // Button background color
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 15.0, // Adjust padding
            horizontal: 20.0,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
          ),
        ),
      ),
      onPressed: _pickImage, // Call the image picker function
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload, color: Colors.white),
          SizedBox(width: 8.0),
          Text(
            "Select Image",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
