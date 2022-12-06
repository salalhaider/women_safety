// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/screens/orders/customModal.dart';
import 'package:women_safety_app/screens/profile/custom_notification_alert.dart';
import 'package:women_safety_app/utils/globals.dart';

class ManageUsersScreen extends StatefulWidget {
  ManageUsersScreen({Key? key}) : super(key: key);

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  // showNotificationAlert() {
  //   String title = '', body = '';
  //   ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  //   Alert(
  //       context: context,
  //       title: "Send Notification",
  //       content: Column(
  //         children: <Widget>[
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Form(
  //             key: formKey,
  //             child: Column(
  //               children: [
  //                 CustomTextField(
  //                   label: 'Title',
  //                   hint: 'Enter Title',
  //                   onSaved: (v) {
  //                     title = v!;
  //                   },
  //                   onValitdate: (v) {
  //                     if (v == null || v.isEmpty) {
  //                       return 'Title cannot be null';
  //                     } else {
  //                       return null;
  //                     }
  //                   },
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 CustomTextField(
  //                   label: 'Detail',
  //                   hint: 'Enter Details',
  //                   maxLines: 4,
  //                   onSaved: (v) {
  //                     body = v!;
  //                   },
  //                   onValitdate: (v) {
  //                     // if (v == null || v.isEmpty) {
  //                     //   return 'Title cannot be null';
  //                     // } else {
  //                     return null;
  //                     // }
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: () async {
  //             if (formKey.currentState!.validate()) {
  //               formKey.currentState!.save();
  //               userRepo.sendNotificationToAll(title, body);
  //               Navigator.pop(context);
  //             }
  //           },
  //           child: ValueListenableBuilder(
  //               valueListenable: isLoadingNotifier,
  //               builder: (context, isLoading, _) {
  //                 return isLoading == false
  //                     ? const Text(
  //                         'Send',
  //                         style: TextStyle(color: Colors.white),
  //                       )
  //                     : const SizedBox(
  //                         height: 15,
  //                         width: 15,
  //                         child: CircularProgressIndicator(
  //                           color: Colors.white,
  //                         ));
  //               }),
  //         ),
  //       ]).show();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(20),
          color: AppColors.baseBackgroundColor,
          child: Column(
            children: [
              // Container(
              //   height: 30,
              //   child: Row(
              //     children: const [

              //       // Text('Filters: ',
              //       //   style: TextStyle(
              //       //     fontSize: 18,
              //       //     color: Colors.blueGrey
              //       //   ),
              //       // )
              //     ],
              //   ),
              // ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () {
                      showNotificationAlert(context);
                    },
                    child: const Text('Send Notification')),
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: userRepo.getAllUserStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot qs = snapshot.data as QuerySnapshot;
                    if (qs.docs.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 180,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              shrinkWrap: true,
                              itemCount: qs.docs.length,
                              itemBuilder: (context, index) {
                                print(qs.docs[index].data());
                                User user = User.fromJson(qs.docs[index].data()
                                    as Map<String, dynamic>);

                                return Card(
                                  color: Colors.blueGrey.shade200,
                                  // !user.isBlocked
                                  //     ? Colors.lightGreen.shade300
                                  //     : Colors.red.shade300,
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Text(
                                                'Name:',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  
                                                  ),
                                              ),
                                              Text(
                                                user.firstName! +
                                                    ' ' +
                                                    user.lastName!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Text(
                                                'Phone Number:',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                              Text(
                                                user.phoneNumber!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Text(
                                                'Email',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                              Text(
                                                user.email ?? '--',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                              Text(
                                                user.isBlocked!
                                                    ? 'Block'
                                                    : 'Unblock',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold  ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    userRepo.updateBlockStatus(
                                                        user.id!,
                                                        !user.isBlocked!);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(!user.isBlocked!
                                                                  ? Colors.red
                                                                      .shade300
                                                                  : Colors.green
                                                                      .shade300)),
                                                  child: Center( //  update
                                                    child: Text(user.isBlocked!
                                                        ? 'Unblock'
                                                        : 'Block'), 
                                                  ),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   width: 10,
                                              // ),
                                              // Expanded(
                                              //   child: ElevatedButton(
                                              //     onPressed: () {},
                                              //     child: const Center(
                                              //       child: Text('Edit'),
                                                //   ),
                                                // ),
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              
                              }),
                        ],
                      );
                    } else {
                      print('emtyyyyyy');
                      return Container();
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                      child: Text('Error'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
