// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/utils/globals.dart';

class ProductRepo {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllProductsStream() {
    return _firestore
        .collection('products')
        .where('isDisable', isNotEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllDisableProductsStream() {
    return _firestore
        .collection('products')
        .where('isDisable', isEqualTo: true)
        .snapshots();
  }

  Future<bool> addNewProduct(StoreProduct product) async {
    print('-------- add new product function ---------');
    DocumentReference docRef = _firestore.collection('products').doc();

    QuerySnapshot qs = await _firestore.collection('products').get();
    int orderNumber = 1;
    if (qs.docs != null && qs.docs.isNotEmpty) {
      orderNumber = qs.docs.length + 1;
    }

    product.id = docRef.id;
    product.articleId = 'wsa-$orderNumber';

    return await _firestore
        .collection('products')
        .doc(docRef.id)
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

  Future<bool> addProductReview(String productId, Map review) async {
    // print('-------- add new product function ---------');
    // DocumentReference docRef = _firestore.collection('products').doc();

    // product.id = docRef.id;
    StoreProduct product = await _firestore
        .collection('products')
        .doc(productId)
        .get()
        .then((value) {
      return StoreProduct.fromJson(value.data()!);
    });

    await _firestore.collection('users').doc(currentUserGlobal!.id!).set(
      {
        if(currentUserGlobal?.reviewedProducts != null)
          'reviewedProducts': FieldValue.arrayUnion([productId]),
        if (currentUserGlobal?.reviewedProducts == null) 
          'reviewedProducts': [productId]
      }, SetOptions(merge: true)
    );

    return await _firestore.collection('products').doc(productId).set({
      if (product.reviews != null) 'reviews': FieldValue.arrayUnion([review]),
      if (product.reviews == null) 'reviews': [review]
    }, SetOptions(merge: true)).then((value) {
      print('-------- review added ---------');
      Fluttertoast.showToast(
        msg: 'Feedback Added. Thanks',
      );
      return true;
    }).catchError((e, s) {
      print('-------- review not added ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<bool> upadateDisablityProduct(StoreProduct product, bool value) async {
    // print('-------- add new product function ---------');
    // DocumentReference docRef = _firestore.collection('products').doc();

    // product.id = docRef.id;

    return await _firestore
        .collection('products')
        .doc(product.id)
        .set({'isDisable': value}, SetOptions(merge: true)).then((value) {
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

  Future<String> uploadPicture(
    Uint8List file,
  ) async {
    // PickedFile pickedFile = file;
    // Uint8List imageFile = await pickedFile.readAsBytes();
    Random random = Random();
    String currPath = 'public/images/products/${random.nextInt(10000)}/';
    Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
    final UploadTask uploadTask =
        storageRef.child('productPhoto').putData(file);
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
}
