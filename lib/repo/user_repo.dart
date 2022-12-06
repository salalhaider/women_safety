// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telephony/telephony.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/utils/firebase_push_notification_service.dart';
import 'package:women_safety_app/utils/globals.dart';

class UserRepo {
  final _firestore = FirebaseFirestore.instance;
  Telephony telephony = Telephony.instance;

  Future getUser(String id) async {
    return _firestore.collection('users').doc(id).get();
  }

  Future<bool> updateUser(User updatedUser) async {
    return await _firestore
        .collection('users')
        .doc(updatedUser.id)
        .update(updatedUser.toJson())
        // .set(updatedUser.toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((e, s) {
      print(e);
      print(s);
      return false;
    });
  }

  updateLastLocation(
    String id,
  ) async {
    await locations.getLastLocation().then((value) async {
      await _firestore
          .collection('users')
          .doc(id)
          .set({'lastLocation': value}, SetOptions(merge: true))
          // .set(updatedUser.toJson(), SetOptions(merge: true))
          .then((value) => true)
          .catchError((e, s) {
            print(e);
            print(s);
          });
    });

    // return await _firestore
    //     .collection('users')
    //     .doc(id)
    //     .set({'lastLocation': lastLocation}, SetOptions(merge: true))
    //     // .set(updatedUser.toJson(), SetOptions(merge: true))
    //     .then((value) => true)
    //     .catchError((e, s) {
    //       print(e);
    //       print(s);
    //     });
  }

  Future<bool> setTrusties(
      String id, Map trusties, Map emergencyContacts,String defaultTrusty) async {
    return _firestore
        .collection('users')
        .doc(id)
        .set({'trusties': trusties, 'emergencyContacts': emergencyContacts,'defaultTrusty':defaultTrusty},
            SetOptions(merge: true))
        .then((value) => true)
        .catchError((e, s) {
          print(e);
          print(s);
          return false;
        });
  }

  Future<bool> setDefaultTrusty(String id, String defaultTrusty) async {
    return _firestore
        .collection('users')
        .doc(id)
        .set({
          'defaultTrusty': defaultTrusty,
        }, SetOptions(merge: true))
        .then((value) => true)
        .catchError((e, s) {
          print(e);
          print(s);
          return false;
        });
  }

  Future<bool> updateBlockStatus(String id, bool value) async {
    return _firestore
        .collection('users')
        .doc(id)
        .set({'isBlocked': value}, SetOptions(merge: true))
        .then((value) => true)
        .catchError((e, s) {
          print(e);
          print(s);
          return false;
        });
  }

  sendNotificationToAll(String title,String body) async {
   return await _firestore.collection('users').get().then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          if (element['notifToken'] != null &&
              element['notifToken'].isNotEmpty)  {
            await sendNotification(element['notifToken'],title,body);
          }
        }
      }
    }).catchError((e, s) {
      print(e);
      print(s);
    });
  }

  Future<String> uploadPicture(PickedFile file, User currentUser) async {
    PickedFile pickedFile = file;
    Uint8List imageFile = await pickedFile.readAsBytes();
    String currPath = 'public/images/brokers/${currentUser.id}/';
    Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
    final UploadTask uploadTask =
        storageRef.child('profilePhoto').putData(imageFile);
    // uploadTask.snapshotEvents.forEach((element) {

    // });

    // String newURL;

    return await uploadTask.whenComplete(() {}).then((value) async {
      String newURL = await value.ref.getDownloadURL();
      print('--------- newUrl ------> $newURL');
      Fluttertoast.showToast(msg: 'Profile Photo Upload Completed');
      return newURL;
    }).catchError((e, s) {
      print(e);
      print(s);
      return '';
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String id) {
    return _firestore.collection('users').doc(id).snapshots();
  }

  createNewUser(String id, User user) async {
    print('-------- create new user function ---------');
    await _firestore
        .collection('users')
        .doc(id)
        .set(user.toJson(), SetOptions(merge: true))
        .then((value) => print('-------- user created ---------'))
        .catchError((e, s) {
      print('-------- user not created ---------');
      print(e);
      print(s);
    });
  }

  checkSmsPermission() async {
    await telephony.requestPhoneAndSmsPermissions;
  }

  Future<bool> sendSMS(String text, List recipient) async {
    List<Future> sendSmsFuture = [];
    recipient.forEach((trusty) {
      sendSmsFuture.add(telephony
          .sendSms(to: trusty, message: text, isMultipart: true)
          .catchError((e, s) {
        print('--- error ---------> $e');
        print('----- stack ---------> $s');
        Fluttertoast.showToast(
            msg: 'Failed',
            backgroundColor: Colors.white,
            textColor: AppColors.primaryColor);
        return false;
      }).then((value) {
        print('done');
        return true;
      }));
    });
    return Future.wait(sendSmsFuture).then((value) => true).catchError((e, s) {
      print(e);
      print(s);
      return false;
    });
  }

  // all users stream
  Stream<QuerySnapshot> getAllUserStream() {
    return _firestore.collection('users').snapshots();
  }
}
