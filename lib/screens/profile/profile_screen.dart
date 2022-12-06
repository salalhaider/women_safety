import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  User? user;
  ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  User? updatedUser;
  final profileFormKey = GlobalKey<FormState>();
  String? password;

  @override
  void initState() {
    currentUser = widget.user;
    updatedUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: AppColors.baseBackgroundColor,
          height: constraints.maxHeight,
          padding: kIsWeb
              ? const EdgeInsets.symmetric(horizontal: 300, vertical: 50)
              : const EdgeInsets.all(15),
          child: Card(
            elevation: kIsWeb ? 6 : 0,
            child: Padding(
              padding:
                  kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.all(0),
              child: Form(
                  key: profileFormKey,
                  child: Padding(
                    padding: kIsWeb?const EdgeInsets.symmetric(horizontal: 50):const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            StatefulBuilder(builder: (context, setBodyState) {
                              return Container(
                                height: 150,
                                width: 150,
                                alignment: Alignment.center,
                                child: updatedUser!.profilePhoto != null &&
                                        updatedUser!.profilePhoto != ''
                                    ? InkWell(
                                        onTap: () async {
                                          String? url =  await loadAssets(
                                              context, currentUser!);
                                          print('-------- url -------->>> $url');
                                          if (url != null && url.isNotEmpty) {
                                            setBodyState(() {
                                              updatedUser!.profilePhoto = url;
                                            });
                                          }
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  updatedUser!.profilePhoto!,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          // loadAssets();
                                          String? url = await loadAssets(
                                              context, currentUser!);
                                          print('-------- url -------->>> $url');
                                          if (url != null && url.isNotEmpty) {
                                            setBodyState(() {
                                              updatedUser!.profilePhoto = url;
                                            });
                                          }
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              // borderRadius: BorderRadius.all(Radius.circular(50)),
                                              color: AppColors.boxHighlight,
                                            ),
                                            child: Center(
                                              child: Stack(
                                                children: [
                                                  const Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 80,
                                                      color:
                                                          AppColors.primaryColor,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      // margin: EdgeInsets.only(bottom: 9),
                                                      decoration:
                                                          const BoxDecoration(
                                                        // borderRadius: BorderRadius.only(
                                                        //   bottomLeft: Radius.circular(40),
                                                        //   bottomRight: Radius.circular(40),
                                                        // ),
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      // alignment: Alignment.bottomCenter,
                                                      child: const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),

                                                      height: 30,
                                                      width: 100,
                                                    ),
                                                  ),
                                                  // Align(
                                                  //     alignment: Alignment.bottomCenter,
                                                  //     child: Container(
                                                  //       height: 20,
                                                  //       color: Colors.white,
                                                  //       alignment: Alignment.bottomCenter,
                                                  //       child: Text('ADD'),
                                                  //     ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            }),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    label: 'First Name',
                                    hint: 'Enter first name',
                                    initialValue: currentUser!.firstName,
                                    onSaved: (v) {
                                      updatedUser!.firstName = v;
                                    },
                                    onValitdate: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Name cannot be null';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                // const SizedBox(width: 20),
                                // Expanded(
                                //   flex: 1,
                                //   child: CustomTextField(
                                //     label: 'Last Name',
                                //     hint: 'Enter Last name',
                                //     isPasswordField: false,
                                //     initialValue: currentUser!.lastName,
                                //     onSaved: (v) {
                                //       updatedUser!.lastName = v;
                                //     },
                                //     onValitdate: (v) {
                                //       if (v == null || v.isEmpty) {
                                //         return 'Name cannot be null';
                                //       } else {
                                //         return null;
                                //       }
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: 'Last Name',
                              hint: 'Enter Last name',
                              isPasswordField: false,
                              initialValue: currentUser!.lastName,
                              onSaved: (v) {
                                updatedUser!.lastName = v;
                              },
                              onValitdate: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Name cannot be null';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: 'Phone Number',
                              hint: 'Enter phone number',
                              initialValue: currentUser!.phoneNumber,
                              onSaved: (v) {
                                updatedUser!.phoneNumber = v;
                              },
                              onValitdate: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Name cannot be null';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            // CustomTextField(
                            //   label: 'Password',
                            //   hint: 'Enter password',
                            //   isPasswordField: true,
                            //   onSaved: (v) {
                            //     if (v != null) {
                            //       password = v.trim();
                            //     }
                            //   },
                            //   onValitdate: (v) {
                            //     if (v == null || v.isEmpty) {
                            //       return 'Name cannot be null';
                            //     } else if (v.length < 8) {
                            //       return 'Password too short';
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    // signUp();
                                    if (profileFormKey.currentState!.validate()) {
                                      profileFormKey.currentState!.save();
                                      bool response =
                                          await userRepo.updateUser(updatedUser!);
                                      if (response) {
                                        showSnackBar(context, 'Profile Updated');
                                      } else {
                                        showSnackBar(context, 'Failed');
                                      }
                                    }
                                  },
                                  child: Container(
                                      width: kIsWeb?200: constraints.maxWidth,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Center(child: Text('Save')),
                                      ))),
                            )
                          ]),
                    ),
                  )),
            ),
          ),
        );
      }),
    );
  }
}
