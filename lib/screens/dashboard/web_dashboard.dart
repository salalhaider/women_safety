// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_web_drwer.dart';
import 'package:women_safety_app/utils/globals.dart';

class WebDashboard extends StatefulWidget {
  final String? userId;
  const WebDashboard({Key? key, this.userId}) : super(key: key);

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  Widget getTableRow(
    String name,
    String phoneNumber,
    String lastLocation,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 2, child: Text(phoneNumber)),
          Expanded(flex: 2, child: Text(lastLocation)),
        ],
      ),
    );
  }

  String getLocationString(Map location) {
    return '${location['street']}, ${location['subLocality']}, ${location['locality']}, ${location['postalCode']}, ${location['country']}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userRepo.getUserStream(widget.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            User currentUser = User.fromJson(snapshot.data!.data()!);
            currentUserGlobal = currentUser;
            print(currentUser.toJson());
            return currentUser.isAdmin!
                ? Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        'Admin Dashboard',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.blueGrey),
                      ),
                      elevation: 2,
                      centerTitle: false,
                      backgroundColor: Colors.white,
                    ),
                    // drawer: CustomWebDrawer(currentUser: currentUser,),
                    body: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 240,
                              child: CustomWebDrawer(currentUser: currentUser),
                            ),
                            Container(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth - 240,
                              padding: const EdgeInsets.symmetric(
                                vertical: 25,
                              ),
                              color: AppColors.baseBackgroundColor,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // --------------------- Top Cards
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 80),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Orders',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors
                                                        .lightGreen.shade400,
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Card(
                                                elevation: 6,
                                                color:
                                                    Colors.lightGreen.shade400,
                                                child: Container(
                                                  height: 100, // update this value
                                                  width: 220, 
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: StreamBuilder(
                                                      stream: orderRepo
                                                          .getAllOrdersStream(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          QuerySnapshot qs =
                                                              snapshot.data
                                                                  as QuerySnapshot;
                                                          // print(snapshot);
                                                          if (qs.docs
                                                              .isNotEmpty) {
                                                            return Text(
                                                                '${qs.docs.length}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          } else {
                                                            print('emtyyyyyy');
                                                            return const Text(
                                                                '0',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          }
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print(snapshot.error);
                                                          return const Center(
                                                            child:
                                                                Text('Error'),
                                                          );
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Users',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors
                                                        .deepPurple.shade400,
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Card(
                                                elevation: 6,
                                                color:
                                                    Colors.deepPurple.shade300,
                                                child: Container(
                                                  height: 100,
                                                  width: 220,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: StreamBuilder(
                                                      stream: userRepo
                                                          .getAllUserStream(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          QuerySnapshot qs =
                                                              snapshot.data
                                                                  as QuerySnapshot;
                                                          // print(snapshot);
                                                          if (qs.docs
                                                              .isNotEmpty) {
                                                            return Text(
                                                                '${qs.docs.length}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          } else {
                                                            print('emtyyyyyy');
                                                            return const Text(
                                                                '0',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          }
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print(snapshot.error);
                                                          return const Center(
                                                            child:
                                                                Text('Error'),
                                                          );
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Products',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors
                                                          .orange.shade400)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Card(
                                                elevation: 6,
                                                color: Colors.orange.shade300,
                                                child: Container(
                                                  height: 100,
                                                  width: 220,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: StreamBuilder(
                                                      stream: productRepo
                                                          .getAllProductsStream(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          QuerySnapshot qs =
                                                              snapshot.data
                                                                  as QuerySnapshot;
                                                          // print(snapshot);
                                                          if (qs.docs
                                                              .isNotEmpty) {
                                                            return Text(
                                                                '${qs.docs.length}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          } else {
                                                            print('emtyyyyyy');
                                                            return const Text(
                                                                '0',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          }
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print(snapshot.error);
                                                          return const Center(
                                                            child:
                                                                Text('Error'),
                                                          );
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Videos',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors
                                                          .blue.shade400)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Card(
                                                elevation: 6,
                                                color: Colors.blue.shade300,
                                                child: Container(
                                                  height: 100,
                                                  width: 220,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: StreamBuilder(
                                                      stream: videoRepo
                                                          .getAllVideosStream(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          QuerySnapshot qs =
                                                              snapshot.data
                                                                  as QuerySnapshot;
                                                          // print(snapshot);
                                                          if (qs.docs
                                                              .isNotEmpty) {
                                                            return Text(
                                                                '${qs.docs.length}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          } else {
                                                            print('emtyyyyyy');
                                                            return const Text(
                                                                '0',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white));
                                                          }
                                                        } else if (snapshot
                                                            .hasError) {
                                                          print(snapshot.error);
                                                          return const Center(
                                                            child:
                                                                Text('Error'),
                                                          );
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // --------------------- orders overview
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 80),
                                      child: Text(
                                        'Orders Overview',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 80),
                                      child: Card(
                                        elevation: 6,
                                        child: Container(
                                          height: 300,
                                          // padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.baseBackgroundColor,
                                            // border: Border.all(
                                            //     width: 2, color: Colors.blueGrey),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueGrey.shade100,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      4),
                                                              topRight:
                                                                  Radius.circular(
                                                                      4))),
                                                  child: getTableRow(
                                                      'Phone Number',
                                                      'Delivery Address',
                                                      'Status'),
                                                ),
                                                StreamBuilder(
                                                  stream: orderRepo
                                                      .getAllOrdersStream(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      QuerySnapshot qs = snapshot
                                                          .data as QuerySnapshot;
                                                      // print(snapshot);
                                                      if (qs.docs.isNotEmpty) {
                                                        return Container(
                                                          // height: 250,
                                                          child: ListView.builder(
                                                            physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  qs.docs.length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                print(qs
                                                                    .docs[index]
                                                                    .data());
                                                                Order _order = Order
                                                                    .fromJson(qs
                                                                            .docs[
                                                                                index]
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>);
                                          
                                                                return getTableRow(
                                                                    _order
                                                                        .phoneNumber!,
                                                                    _order
                                                                        .deliveryAddress!,
                                                                    _order
                                                                        .status!);
                                                              }),
                                                        );
                                                      } else {
                                                        print('emtyyyyyy');
                                                        return Container();
                                                      }
                                                    } else if (snapshot
                                                        .hasError) {
                                                      print(snapshot.error);
                                                      return const Center(
                                                        child: Text('Error'),
                                                      );
                                                    } else {
                                                      return SizedBox(
                                                        height: MediaQuery.of(context).size.height,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 80),
                                      child: Text(
                                        'Users Overview',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 80),
                                      child: Card(
                                        elevation: 6,
                                        child: Container(
                                          height: 300,
                                          // padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.baseBackgroundColor,
                                            // border: Border.all(
                                            //     width: 2, color: Colors.blueGrey),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .blueGrey.shade100,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      4),
                                                              topRight:
                                                                  Radius.circular(
                                                                      4))),
                                                  child: getTableRow(
                                                      'Name',
                                                      'Phone number',
                                                      'Last location'),
                                                ),
                                                StreamBuilder(
                                                  stream:
                                                      userRepo.getAllUserStream(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      QuerySnapshot qs = snapshot
                                                          .data as QuerySnapshot;
                                                      // print(snapshot);
                                                      if (qs.docs.isNotEmpty) {
                                                        return ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                qs.docs.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              print(qs
                                                                  .docs[index]
                                                                  .data());
                                                              User? _user;
                                                              try {
                                                                _user = User.fromJson(qs
                                                                        .docs[index]
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>);
                                                              } catch (e, s) {
                                                                print(e);
                                                                print(s);
                                                              }
                                                              if (_user !=
                                                                  null) {
                                                                return getTableRow(
                                                                    _user.firstName! +
                                                                        ' ' +
                                                                        _user
                                                                            .lastName!,
                                                                    _user
                                                                        .phoneNumber!,
                                                                    getLocationString(
                                                                        _user
                                                                            .lastLocation!));
                                                              } else {
                                                                return const SizedBox();
                                                              }
                                                            });
                                                      } else {
                                                        print('emtyyyyyy');
                                                        return Container();
                                                      }
                                                    } else if (snapshot
                                                        .hasError) {
                                                      print(snapshot.error);
                                                      return const Center(
                                                        child: Text('Error'),
                                                      );
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Scaffold(
                    body: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 100,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Sorry you are not authorized to use this portal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Please contact admin. Thank you',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      authRepo.logOut();
                                    },
                                    child: Text(
                                      'Log out',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Error loading user')
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            return Scaffold(
              body: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }
        });
  }
}
