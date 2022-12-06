// ignore_for_file: avoid_print

// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/models/video.dart';

class VideoRepo {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllVideosStream() {
    return _firestore.collection('videos').snapshots();
  }

  Future<bool> addNewVideo(Video video) async {
    print('-------- add new videp function ---------');
    DocumentReference docRef = _firestore.collection('videos').doc();

    video.id = docRef.id;

    return await _firestore
        .collection('videos')
        .doc(docRef.id)
        .set(video.toJson(), SetOptions(merge: true))
        .then((value) {
      print('-------- Video added ---------');
      return true;
    }).catchError((e, s) {
      print('-------- Video not added ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<bool> editVideo(Video video) async {
    print('-------- edit video function ---------');
    return await _firestore
        .collection('videos')
        .doc(video.id)
        .set(video.toJson(), SetOptions(merge: true))
        .then((value) {
      print('-------- Video edited ---------');
      return true;
    }).catchError((e, s) {
      print('-------- Video not edit ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<bool> editProduct(StoreProduct product) async {
    // print('-------- add new product function ---------');
    // DocumentReference docRef = _firestore.collection('products').doc();

    // product.id = docRef.id;

    return await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toJson(), SetOptions(merge: true))
        .then((value) {
      print('-------- product added ---------');
      return true;
    }).catchError((e, s) {
      print('-------- product not added ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<bool> deleteProduct(StoreProduct product) async {
    return await _firestore
        .collection('products')
        .doc(product.id)
        .delete()
        .then((value) {
      print('-------- product Deleted ---------');
      return true;
    }).catchError((e, s) {
      print('-------- product not deleted ---------');
      print(e);
      print(s);
      return false;
    });
  }

  // Future<String> uploadPicture(
  //   Uint8List file,
  // ) async {
  //   // PickedFile pickedFile = file;
  //   // Uint8List imageFile = await pickedFile.readAsBytes();
  //   Random random = Random();
  //   String currPath = 'public/images/products/${random.nextInt(10000)}/';
  //   Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
  //   final UploadTask uploadTask =
  //       storageRef.child('productPhoto').putData(file);
  //   // uploadTask.snapshotEvents.forEach((element) {

  //   // });

  //   // String newURL;

  //   return await uploadTask.whenComplete(() {}).then((value) async {
  //     String newURL = await value.ref.getDownloadURL();
  //     print('--------- newUrl ------> $newURL');
  //     Fluttertoast.showToast(msg: 'Profile Photo Upload Completed');
  //     return newURL;
  //   }).catchError((e, s) {
  //     print(e);
  //     print(s);
  //     return '';
  //   });
  // }

  Future<String> uploadVideo(PlatformFile file, String title) async {
    // PickedFile pickedFile = file;
    // Uint8List imageFile = await pickedFile.readAsBytes();
    Random random = Random();
    String currPath = 'public/videos/tutorials/${random.nextInt(10000)}/';
    Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
    final UploadTask uploadTask = storageRef
        .child('video')
        .putData(file.bytes!); //.putFile(File(file.path!)); // .putData(file);
    // uploadTask.snapshotEvents.forEach((element) {

    // });

    // String newURL;

    return await uploadTask.whenComplete(() {}).then((value) async {
      String newURL = await value.ref.getDownloadURL();
      print('--------- newUrl ------> $newURL');
      // addNewVideo(Video(newURL, title));
      Fluttertoast.showToast(msg: 'Profile Photo Upload Completed');
      return newURL;
    }).catchError((e, s) {
      print(e);
      print(s);
      return '';
    });
  }
}
