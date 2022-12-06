// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/screens/dashboard/dashboard_page.dart';
import 'package:women_safety_app/utils/globals.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginKey = GlobalKey<FormState>();
  final signUpKey = GlobalKey<FormState>();
  String? firstName, lastName, phoneNumber, email, password,confirmPassword;
  ValueNotifier<bool> signInScreenNotifier = ValueNotifier(true);
  TextEditingController passResetController = TextEditingController();
  void loginUser() {
    var form = signInScreenNotifier.value
        ? loginKey.currentState
        : signUpKey.currentState;
    if (form!.validate()) {
      print('-------- data validated ---------');
      form.save();
      authRepo.signIn(email!, password!,context);
    }
  }

  Future signUp() async {
    var form = signInScreenNotifier.value
        ? loginKey.currentState
        : signUpKey.currentState;
    if (form!.validate()) {
      print('-------- data validated ---------');
      form.save();
      User newUser = User( firstName:firstName, lastName:lastName, phoneNumber:phoneNumber, trusties: {}, profilePhoto:'',emergencyContacts: {'police':'1111','ambulance':'1111'},isAdmin:false,isBlocked: false,email:email,defaultTrusty: '');
      print(newUser.toJson());
      await authRepo.signUpWithEmail(
          email: email!,
          password: password!,
          newUser: newUser,
          context: context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kIsWeb?Colors.white: Colors.blueGrey,
        elevation: kIsWeb? 4:0,
        title: const Text(
          'WSA',
          style: TextStyle(color: kIsWeb? Colors.blueGrey:Colors.white,fontWeight: FontWeight.w600),
        ),
        actions: [
          if(!kIsWeb)
          TextButton(
              onPressed: () {
                signInScreenNotifier.value = true;
              },
              child: ValueListenableBuilder(
                  valueListenable: signInScreenNotifier,
                  builder: (context, bool isSignInScreen, _) {
                    return Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kIsWeb? Colors.blueGrey:Colors.white,
                          fontWeight: isSignInScreen
                              ? FontWeight.w900
                              : FontWeight.w400),
                    );
                  })),
          if(!kIsWeb)
          TextButton(
              onPressed: () {
                signInScreenNotifier.value = false;
              },
              child: ValueListenableBuilder(
                  valueListenable: signInScreenNotifier,
                  builder: (context, bool isSignInScreen, _) {
                    return Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: kIsWeb? Colors.blueGrey:Colors.white,
                          fontWeight: isSignInScreen
                              ? FontWeight.w400
                              : FontWeight.w900),
                    );
                  })),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () {
            return Future.delayed(Duration.zero);
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: constraints.maxWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: signInScreenNotifier,
                            builder: (context, bool isSignInScreen, _) {
                              return Text(
                                isSignInScreen
                                    ? 'Welcome back,'
                                    : 'Hey, get on board',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        ValueListenableBuilder(
                            valueListenable: signInScreenNotifier,
                            builder: (context, bool isSignInScreen, _) {
                              return Text(
                                isSignInScreen
                                    ? 'Sign in to continue'
                                    : 'Sign up to continue',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    height: constraints.maxHeight,
                    width:  constraints.maxWidth > 700? 700: constraints.maxWidth,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: ValueListenableBuilder(
                        valueListenable: signInScreenNotifier,
                        builder: (context, bool isSignInScreen, _) {
                          return SingleChildScrollView(
                            child: isSignInScreen
                                ? Form(
                                    key: loginKey,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          CustomTextField(
                                            label: 'Email',
                                            hint: 'Enter email address',
                                            keyboardType: TextInputType.emailAddress,
                                            onSaved: (v) {
                                              if (v != null) {
                                                email = v.trim();
                                              }
                                            },
                                            onValitdate: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Email cannot be null';
                                              } else if (!v.contains('@')) {
                                                return 'Please enter valid email';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CustomTextField(
                                            label: 'Password',
                                            hint: 'Enter password',
                                            isPasswordField: true,
                                            onSaved: (v) {
                                              if (v != null) {
                                                password = v.trim();
                                              }
                                            },
                                            onValitdate: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Password cannot be null';
                                              } else if (v.length < 8) {
                                                return 'Password too short';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        String value = '';
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            AppBar(
                                                              title: const Text(
                                                                  'Reset Password'),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              width: 500,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Please Enter Your Email ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    passResetController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration: const InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                    hintText:
                                                                        'Please enter your email',
                                                                    label: Text(
                                                                        'Email')),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            resetEmail =
                                                                            passResetController.text;
                                                                        if (resetEmail !=
                                                                                null &&
                                                                            resetEmail.isNotEmpty &&
                                                                            resetEmail.contains('@')) {
                                                                          authRepo
                                                                              .resetPassword(context, resetEmail)
                                                                              .then((value) {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        }
                                                                        print(passResetController
                                                                            .text);
                                                                        print(
                                                                            value);
                                                                      },
                                                                      child: Text(
                                                                          'Reset Password')),
                                                            )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  loginUser();
                                                },
                                                child: Container(
                                                    width: constraints.maxWidth > 700? 150:constraints.maxWidth,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60)),
                                                    child: const Center(
                                                        child:
                                                            Text('SIGN IN')))),
                                          )
                                        ]),
                                  )
                                : Form(
                                    key: signUpKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // const SizedBox(
                                        //   height: 50,
                                        // ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: CustomTextField(
                                                label: 'First Name',
                                                hint: 'Enter first name',
                                                onSaved: (v) {
                                                  firstName = v;
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
                                            const SizedBox(width: 20),
                                            Expanded(
                                              flex: 1,
                                              child: CustomTextField(
                                                label: 'Last Name',
                                                hint: 'Enter Last name',
                                                isPasswordField: false,
                                                onSaved: (v) {
                                                  lastName = v;
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
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          label: 'Phone Number',
                                          hint: 'Enter phone number',
                                          keyboardType: TextInputType.number,
                                          onSaved: (v) {
                                            phoneNumber = v;
                                          },
                                          onValitdate: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Phone number cannot be null';
                                            } else if (v.contains(RegExp(r'[a-z]'))) {
                                              return 'Phone number must contains number only';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          label: 'Email Address',
                                          hint: 'Enter email address',
                                          keyboardType: TextInputType.emailAddress,
                                          onSaved: (v) {
                                            if (v != null) {
                                              email = v.trim();
                                            }
                                          },
                                          onValitdate: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Email cannot be null';
                                            } else if (!v.contains('@')) {
                                              return 'Please enter valid email';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          label: 'Password',
                                          hint: 'Enter password',
                                          onSaved: (v) {
                                            if (v != null) {
                                              password = v.trim();
                                            }
                                          },
                                          onChanged: (v) {
                                            if (v != null) {
                                              password = v.trim();
                                            }
                                          },
                                          onValitdate: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Password cannot be null';
                                            } else if (v.length < 8) {
                                              return 'Password too short';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        CustomTextField(
                                          label: 'Confirm Password',
                                          hint: 'Enter password',
                                          onSaved: (v) {
                                            if (v != null) {
                                              confirmPassword = v.trim();
                                            }
                                          },
                                          onChanged: (v) {
                                            if (v != null) {
                                              confirmPassword = v.trim();
                                            }
                                          },
                                          onValitdate: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Field cannot be null';
                                            } else if (password != confirmPassword) {
                                              return 'Password does not match';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                signUp();
                                              },
                                              child: Container(
                                                   width: constraints.maxWidth > 700? 150:constraints.maxWidth,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                  child: const Center(
                                                      child: Text('SIGN UP')))),
                                        )
                                      ],
                                    ),
                                  ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
