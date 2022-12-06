// ignore_for_file: avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdi/mdi.dart';
import 'package:women_safety_app/main.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_button.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/screens/profile/profile_screen.dart';
import 'package:women_safety_app/screens/setting/settings.dart';
import 'package:women_safety_app/screens/store/store_screen.dart';
import 'package:women_safety_app/screens/videos/video_screen.dart';
import 'package:women_safety_app/utils/firebase_push_notification_service.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class DashboardPage extends StatefulWidget {
  final String? userId;
  const DashboardPage({Key? key, this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    // routeObserver.subscribe(this, ModalRoute.of(context));
    checkPermissions();
    userRepo.updateLastLocation(widget.userId!);
  }

  @override
  didPopNext() {
    print('*********** pop ************');
  }

  checkPermissions() async {
    await locations.checkLocationPermission();
    await userRepo.checkSmsPermission();
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  // void showSettingModalBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       // isDismissible: true,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(25), topRight: Radius.circular(25))),
  //       builder: (context) {
  //         return Container(
  //           // height: 0.7 * MediaQuery.of(context).size.height,
  //           // padding: const EdgeInsets.all(20),
  //           decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(25),
  //                 topRight: Radius.circular(25),
  //               )),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Flexible(
  //                   child: IconButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       icon: const Icon(Icons.arrow_back)),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: CustomTextField(
  //                     label: 'Manage Trusty',
  //                     hint: '03331234123',
  //                     initialValue: '03338682868',
  //                     onSaved: (v) {
  //                       // email = v.trim();
  //                     },
  //                     onValitdate: (v) {
  //                       if (v == null || v.isEmpty) {
  //                         return 'Name cannot be null';
  //                       } else if (!v.contains('@')) {
  //                         return 'Please enter valid email';
  //                       } else {
  //                         return '';
  //                       }
  //                     },
  //                   ),
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.all(20.0),
  //                   child: CustomButton(
  //                     title: 'Save',
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

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
            if(currentUser.isBlocked!){
               return LayoutBuilder(
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
                            Icons.block ,
                            size: 100,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Blocked !',
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    fontSize: 24,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Please contact admin to continue.',
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
              );
            }
            return AdvancedDrawer(
              backdropColor: Colors.blueGrey,
              controller: _advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              animateChildDecoration: true,
              rtlOpening: false,
              // openScale: 1.0,
              disabledGestures: false,
              childDecoration: const BoxDecoration(
                // NOTICE: Uncomment if you want to add shadow behind the page.
                // Keep in mind that it may cause animation jerks.
                // boxShadow: <BoxShadow>[
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 10.0,
                //   ),
                // ],
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.blueGrey,
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            value.visible ? Icons.clear : Icons.menu,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage(
                                    user: currentUser,
                                  ))), //showSettingModalBottomSheet(),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                body: LayoutBuilder(builder: (context, bodyConstrains) {
                  return Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.all(15),
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(120)),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        color: Colors.grey.shade300,
                                      ),
                                      child: currentUser.profilePhoto == null ||
                                              currentUser.profilePhoto!.isEmpty
                                          ? Center(
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.blueGrey.shade800,
                                              ),
                                            )
                                          : ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    currentUser.profilePhoto!,
                                              ),
                                            ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        currentUser.firstName! +
                                            ' ' +
                                            currentUser.lastName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 20,
                                                color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        currentUser.phoneNumber!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 16,
                                                color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 8,
                          child: Container(
                            width: bodyConstrains.maxWidth,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                )),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Are you in emergency?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 20,
                                                color: Colors.blueGrey),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Press the button help will reach you soon.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200,
                                                color:
                                                    Colors.blueGrey.shade400),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Stack(
                                      // overflow: Overflow.visible,
                                      children: [
                                        currentUser.trusties != null &&
                                                currentUser.trusties!.isNotEmpty
                                            ? Container()
                                            : MaterialBanner(
                                                content:
                                                    Text('Please add trusties'),
                                                actions: [
                                                    ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SettingsPage(
                                                                              user: currentUser,
                                                                            ))),
                                                        child:
                                                            Text('Add trusty'))
                                                  ]),
                                        Center(
                                          child: Container(
                                            height: 250,
                                            width: 250,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(140)),
                                                color: Colors.red.shade50),
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(140)),
                                                  color: Colors.red.shade100),
                                              child: ElevatedButton(
                                                // onPressed: () async {
                                                //   if (notifToken != null) {
                                                //     print(
                                                //         ' -- notif token ---------> $notifToken \n\n');
                                                //     await sendNotification(
                                                //         notifToken!);
                                                //   } else {
                                                //     print('\n\n--------- notif token is null ----------\n\n');
                                                //   }
                                                // },
                                                
                                                onPressed: () async {
                                                  Position currPosition =
                                                      await locations
                                                          .determinePosition();
                                                  List<Placemark> currLocation =
                                                      await locations
                                                          .getLocationFromCoardinates(
                                                              currPosition
                                                                  .latitude,
                                                              currPosition
                                                                  .longitude);
                                                  // currLocation.name
                                                  userRepo.updateLastLocation(
                                                      currentUser.id!);
                                                  print(
                                                      '\n -------- Current Latitude ${currPosition.latitude}');
                                                  print(
                                                      '-------- Current Longitude ${currPosition.longitude} \n');
                                                  // print('\n ---------- last known location ----> ${currLocation.first.name} \n');
                                                  for (var element
                                                      in currLocation) {
                                                    print(
                                                        '\n ---------- location ---------? ${element.toJson()} \n');
                                                  }
                                                  String address =
                                                      '${currLocation.first.street}, ${currLocation.first.subLocality}, ${currLocation.first.locality}, ${currLocation.first.postalCode}, ${currLocation.first.country}';
                                                  String mapsLink =
                                                      'https://www.google.com/maps/search/?api=1&query=${currPosition.latitude},${currPosition.longitude}';
                                                  String sms =
                                                      " **** TEST Message **** \nLatitude: ${currPosition.latitude} \nLongitude: $address \n$mapsLink";
                                                  print(
                                                      '\n ------- sms -------- $sms \n');
                                                  if (currentUser.trusties !=
                                                          null &&
                                                      currentUser.trusties!
                                                          .isNotEmpty) {
                                                    await userRepo
                                                        .sendSMS(
                                                            sms,
                                                            currentUser
                                                                .trusties!.keys
                                                                .toList())
                                                        .then((value) {
                                                      print(value);
                                                      if (value) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title:
                                                                    Container(
                                                                  height: bodyConstrains
                                                                          .maxHeight *
                                                                      0.3,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.cancel)),
                                                                          )),
                                                                      const Expanded(
                                                                          flex:
                                                                              6,
                                                                          child:
                                                                              Icon(
                                                                            Icons.wifi_tethering_error_sharp,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                80,
                                                                          )),
                                                                      const Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Text('Help is on the way')),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                    });
                                                    await makePhoneCall(
                                                        currentUser.defaultTrusty != null && currentUser.defaultTrusty!.isNotEmpty ? currentUser.defaultTrusty:currentUser
                                                            .trusties!.keys
                                                            .toList()
                                                            .first);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please add trusties',
                                                        textColor: AppColors
                                                            .primaryColor,
                                                        backgroundColor:
                                                            Colors.white);
                                                  }
                                                },

                                                style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  primary: Colors.red,
                                                  fixedSize:
                                                      const Size(200, 200),
                                                  shape: const CircleBorder(),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'SOS',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: InkWell(
                                              onTap: () async {
                                                await makePhoneCall(currentUser
                                                            .emergencyContacts?[
                                                        'police'] ??
                                                    '1111');
                                              },
                                              child: Card(
                                                color: Colors.blueGrey,
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Icon(
                                                      Icons.local_police,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Call Police',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                        // Expanded(flex: 3, child: Container()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: InkWell(
                                              splashColor: Colors.black,
                                              onTap: () async {
                                                await makePhoneCall(currentUser
                                                            .emergencyContacts?[
                                                        'ambulance'] ??
                                                    '1111');
                                              },
                                              child: Card(
                                                color: Colors.red,
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Icon(
                                                      Mdi.ambulance,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Call Rescue',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  );
                }),
              ),
              drawer: SafeArea(
                child: ListTileTheme(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 128.0,
                        height: 128.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 64.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'WSA',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                          ),
                        ),
                        // child: Image.asset(
                        //   'assets/images/flutter_logo.png',
                        // ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage(
                                        userId: widget.userId,
                                      )));
                        },
                        leading: const Icon(Icons.home),
                        title: const Text('Home'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        user: currentUser,
                                      )));
                        },
                        leading: const Icon(Icons.account_circle_rounded),
                        title: const Text('Profile'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StoreScreen()));
                        },
                        leading: const Icon(Icons.store),
                        title: const Text('Store'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoScreen()));
                        },
                        leading: const Icon(Icons.play_arrow),
                        title: const Text('Videos'),
                      ),
                      // ListTile(
                      //   onTap: () {},
                      //   leading: const Icon(Icons.settings),
                      //   title: const Text('Settings'),
                      // ),
                      ListTile(
                        onTap: () {
                          authRepo.logOut();
                        },
                        leading: const Icon(Icons.logout_sharp),
                        title: const Text('Log out'),
                      ),
                      const Spacer(),
                      // DefaultTextStyle(
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.white54,
                      //   ),
                      //   child: Container(
                      //     margin: const EdgeInsets.symmetric(
                      //       vertical: 16.0,
                      //     ),
                      //     child: const Text('Terms of Service | Privacy Policy'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
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
