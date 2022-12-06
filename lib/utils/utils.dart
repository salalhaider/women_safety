// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
//Comment for web
//  import 'package:image_picker_web/image_picker_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/utils/globals.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
    ),
  );
}

Future<void> makePhoneCall(String number) async {
  number =
      'tel://${number.startsWith('0') ? number.replaceFirst('0', '+92') : number}';
  print(number);
  await FlutterPhoneDirectCaller.callNumber(number).catchError((e, s) {
    print(e);
    print(s);
    throw 'Could not launch $number';
  }).then((value) async {
    {
      Fluttertoast.showToast(msg: 'Calling...');
    }
  });
}

Future<String?> loadAssets(BuildContext context, User currentUser) async {
  ImagePicker imagePicker = ImagePicker();
  var imageSource;

  if (!kIsWeb) {
    try {
      imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Select the image source"),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              padding: EdgeInsets.all(10),
              child: Text("Camera"),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            FlatButton(
              padding: EdgeInsets.all(10),
              child: Text("Gallery"),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      );
    } catch (ex, s) {
      print(ex);
      print(s);
      // return '';
    }
  } else {
    imageSource = ImageSource.gallery;
  }

  PickedFile pickedFile;
  if (imageSource != null) {
    final file =
        await imagePicker.getImage(imageQuality: 60, source: imageSource);
    if (file != null) {
      // formKey.currentState.save();
      // setState(() {
      //   isUploading = true;
      // });
      //   pickedFile = file;
      //   Uint8List imageFile = await pickedFile.readAsBytes();
      //   String currPath = 'public/images/brokers/${widget.currentBroker.id}/';
      //   Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
      //   final UploadTask uploadTask =
      //       storageRef.child('profilePhoto').putData(imageFile);
      //   uploadTask.snapshotEvents.forEach((element) {
      //     setState(() {
      //       isUploading = true;
      //     });
      //   });

      //   String newURL;

      //   uploadTask.whenComplete(() {}).then((value) async {
      //     newURL = await value.ref.getDownloadURL();
      //     Broker newBroker = thisBroker;

      //     newBroker.profilePhoto = newURL;
      //     setState(() {
      //       thisBroker = newBroker;
      //       profilePhoto = newURL;
      //       isUploading = false;
      //     });

      //     Fluttertoast.showToast(msg: 'Profile Photo Upload Completed');
      //     return value;
      //   });
      String? url = await userRepo.uploadPicture(file, currentUser);
      print('------ utils url -------> $url');
      // ignore: unnecessary_null_comparison
      if (url == null || url.isEmpty) {
        Fluttertoast.showToast(
          msg: 'No Image Uploaded.',
        );
        return '';
      } else {
        return url;
      }
    }
  } else {
    Fluttertoast.showToast(
      msg: 'No Image Uploaded.',
    );
    return '';
  }
  // return '';
}

Future<String?> loadAssetsWeb() async {
  Uint8List? bytesFromPicker;
  try {
    // comment for web
    //  bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  } catch (e, s) {
    print(e);
    print(s);
  }
  // print(bytesFromPicker);
  String? url;
  if (bytesFromPicker != null) {
    url = await productRepo.uploadPicture(
      bytesFromPicker,
    );
    return url;
  } else {
    Fluttertoast.showToast(
      msg: 'No Image Uploaded.',
    );
    return '';
  }
}

Future<String?> loadVideosWeb() async {
  // File? bytesFromPicker;

  FilePickerResult? bytesFromPicker;
  try {
    bytesFromPicker = await FilePicker.platform.pickFiles(type: FileType.video);
    // await ImagePickerWeb.getVideoAsFile(); // .getVideoAsBytes();
  } catch (e, s) {
    print(e);
    print(s);
  }
  // print(bytesFromPicker);
  String? url;
  if (bytesFromPicker != null) {
    url = await videoRepo.uploadVideo(bytesFromPicker.files.first, '');
    return url;
  } else {
    Fluttertoast.showToast(
      msg: 'No Image Uploaded.',
    );
    return '';
  }
}
