// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/models/product.dart';

class OrderRepo {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllOrdersStream() {
    return _firestore.collection('orders').snapshots();
  }

  Stream<QuerySnapshot> getUserOrdersStream(String id) {
    return _firestore
        .collection('orders')
        .where('orderBy.id', isEqualTo: id)
        .snapshots();
  }

  Future<bool> addNewOrder(Order order) async {
    print('-------- add new product function ---------');
    DocumentReference docRef = _firestore.collection('orders').doc();

    QuerySnapshot qs = await _firestore.collection('orders').get();
    int orderNumber = 1;
    if (qs.docs != null && qs.docs.isNotEmpty) {
      orderNumber = qs.docs.length + 1;
    }

    for (var element in order.products) {
      await _firestore
          .collection('products')
          .doc(element['productId'])
          .get()
          .then((value) async{
        Map<String,dynamic>? tempMap = value.data();
        if(tempMap != null && tempMap.isNotEmpty && tempMap['quantity'] > 0) {
          await _firestore
            .collection('products')
            .doc(element['productId'])
            .set({
              'quantity': tempMap['quantity'] - 1,
              if(tempMap['totalOrders'] != null)
                'totalOrders': FieldValue.arrayUnion([order.id]),
              if(tempMap['totalOrders'] == null)
                'totalOrders': [order.id]  
              
            }, SetOptions(merge: true));
        }
      });
    }

    order.id = docRef.id;
    order.orderNumber = orderNumber;

    return await _firestore
        .collection('orders')
        .doc(docRef.id)
        .set(order.toJson(), SetOptions(merge: true))
        .then((value) {
      print('-------- Order added ---------');
      return true;
    }).catchError((e, s) {
      print('-------- Order not added ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<bool> editProduct(StoreProduct product) async {
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

  Future<bool> updateStatus(Order order, String status) async {
    return await _firestore
        .collection('orders')
        .doc(order.id)
        .set({'status': status}, SetOptions(merge: true)).then((value) {
      print('-------- Order updated---------');
      return true;
    }).catchError((e, s) {
      print('-------- order not updated ---------');
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
