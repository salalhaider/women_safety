// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:ui' as ui;
// import '../../utils/globals.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Appbar')),
//       body: LayoutBuilder(
//         builder: (context, bodyConstraints) {
//           return Container(
//             height: bodyConstraints.maxHeight,
//             padding: const EdgeInsets.all(10),
//             child: Form(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children:  [ 
//                   const Text('Please enter your phone number'),
//                   Directionality(
//                             textDirection: ui.TextDirection.ltr,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                       margin: EdgeInsets.symmetric(vertical: 5),
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 15),
//                                       decoration: BoxDecoration(
//                                           // borderRadius: BorderRadius.circular(5),
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   color: Colors.black38,
//                                                   width: 1))),
//                                       child: FittedBox(
//                                         fit: BoxFit.scaleDown,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Image.asset(
//                                               'assets/pakistan_img.png',
//                                               height: 20,
//                                               width: 20,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Text(
//                                               '+92',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .headline2,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )),
//                                 Expanded(
//                                     flex: 3,
//                                     child: Form(
//                                       key: _formKey,
//                                       child: Container(
//                                         margin:
//                                             EdgeInsets.symmetric(vertical: 5),
//                                         padding: EdgeInsets.all(5),
//                                         child: TextFormField(
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 !value.startsWith('3') ||
//                                                 value.length < 10)
//                                               return 'phoneValidation'.tr();
//                                             else
//                                               return null;
//                                           },
//                                           controller: _phoneController,
//                                           maxLength: 10,
//                                           decoration: InputDecoration(
//                                             counterText: '',
//                                             focusedBorder: UnderlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.blue,
//                                                   width: 1.0),
//                                             ),
//                                             enabledBorder: UnderlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors.black38,
//                                                   width: 1.0),
//                                             ),
//                                             hintText: 'phoneNo'.tr(),
//                                             hintStyle: Theme.of(context)
//                                                 .textTheme
//                                                 .headline2,
//                                           ),
//                                           keyboardType:
//                                               TextInputType.numberWithOptions(
//                                                   decimal: false),
//                                           inputFormatters: [
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                         ),
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           ),
                        
//                 ],
//               )
//             ),
//           );
//       }),
//     );
//   }
// }

// // class NumberPage extends StatefulWidget {
// //   @override
// //   _NumberPageState createState() => _NumberPageState();
// // }

// // class _NumberPageState extends State<NumberPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   TextEditingController _phoneController = TextEditingController();
// //   ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

// //   void goToCode() {
// //     final form = _formKey.currentState;
// //     if (form!.validate()) {
// //       loadingNotifier.value = true;
// //       // loginCubit.goToLoginCode(_phoneController.text);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           backgroundColor: AppColors.primaryColor,
// //           title: Text(
// //             'createAccount',
// //             style: Theme.of(context)
// //                 .textTheme
// //                 .headline1!
// //                 .copyWith(color: Colors.white),
// //           ),
// //           centerTitle: true,
// //           automaticallyImplyLeading: true,
// //           leading: IconButton(
// //               icon: const Icon(
// //                 Icons.arrow_left,
// //                 size: 16,
// //               ),
// //               onPressed: () {} //=> loginCubit.goToLoginInit()
// //               ),
// //         ),
// //         body: LayoutBuilder(
// //           builder: (contex,bodyConstraints) {
// //             return Container(
// //               height: bodyConstraints.maxHeight,
// //               padding: EdgeInsets.all(15),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 mainAxisSize: MainAxisSize.max,
// //                 children: [
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Container(
// //                           margin: EdgeInsets.all(10),
// //                           child: Text(
// //                             'phonePrompt',
// //                             style: Theme.of(context)
// //                                 .textTheme
// //                                 .headline1!
// //                                 .copyWith(color: Colors.black),
// //                           )),
// //                       Container(
// //                         margin: EdgeInsets.all(5),
// //                         child: Directionality(
// //                           textDirection: ui.TextDirection.ltr,
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             crossAxisAlignment: CrossAxisAlignment.center,
// //                             mainAxisSize: MainAxisSize.max,
// //                             children: [
// //                               Expanded(
// //                                   flex: 1,
// //                                   child: Container(
// //                                     margin: const EdgeInsets.symmetric(vertical: 5),
// //                                     padding: const EdgeInsets.symmetric(
// //                                         horizontal: 5, vertical: 15),
// //                                     decoration: BoxDecoration(
// //                                         // borderRadius: BorderRadius.circular(5),
// //                                         border: Border(
// //                                             bottom: BorderSide(
// //                                                 color: Colors.black38,
// //                                                 width: 1))),
// //                                     child: FittedBox(
// //                                       fit: BoxFit.scaleDown,
// //                                       child: Row(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.center,
// //                                         children: [
// //                                           Image.asset(
// //                                             'assets/pakistan_img.png',
// //                                             height: 20,
// //                                             width: 20,
// //                                           ),
// //                                           const SizedBox(
// //                                             width: 5,
// //                                           ),
// //                                           Text(
// //                                             '+92',
// //                                             style: Theme.of(context)
// //                                                 .textTheme
// //                                                 .headline2,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   )),
// //                               Expanded(
// //                                   flex: 3,
// //                                   child: Form(
// //                                     key: _formKey,
// //                                     child: Container(
// //                                       margin: const
// //                                           EdgeInsets.symmetric(vertical: 5),
// //                                       padding: const EdgeInsets.all(5),
// //                                       child: TextFormField(
// //                                         validator: (value) {
// //                                           if (value == null ||
// //                                               !value.startsWith('3') ||
// //                                               value.length < 10) {
// //                                               return 'phoneValidation';
// //                                            } else {
// //                                             return null;
// //                                           }
// //                                         },
// //                                         controller: _phoneController,
// //                                         maxLength: 10,
// //                                         decoration: InputDecoration(
// //                                           counterText: '',
// //                                           focusedBorder: const UnderlineInputBorder(
// //                                             borderSide: BorderSide(
// //                                                 color: Colors.blue,
// //                                                 width: 1.0),
// //                                           ),
// //                                           enabledBorder: const UnderlineInputBorder(
// //                                             borderSide: BorderSide(
// //                                                 color: Colors.black38,
// //                                                 width: 1.0),
// //                                           ),
// //                                           hintText: 'phoneNo',
// //                                           hintStyle: Theme.of(context)
// //                                               .textTheme
// //                                               .headline2,
// //                                         ),
// //                                         keyboardType:
// //                                             const TextInputType.numberWithOptions(
// //                                                 decimal: false),
// //                                         inputFormatters: [
// //                                           FilteringTextInputFormatter
// //                                               .digitsOnly
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ))
// //                             ],
// //                           ),
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Container(
// //                         margin: const EdgeInsets.all(5),
// //                         child: ValueListenableBuilder(
// //                             valueListenable: loadingNotifier,
// //                             builder: (context, isLoading, _) {
// //                               return MaterialButton(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(5.0),
// //                                 ),
// //                                 padding: const EdgeInsets.all(10),
// //                                 onPressed: goToCode,
// //                                 color: Theme.of(context).buttonColor,
// //                                 child: Center(
// //                                     child: isLoading != null
// //                                         ? const CircularProgressIndicator(color: AppColors.primaryColor,)//customLoader(Colors.white, size: 25)
// //                                         : Text(
// //                                             'next',
// //                                             style: Theme.of(context)
// //                                                 .textTheme
// //                                                 .button,
// //                                           )),
// //                               );
// //                             }),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.all(10),
// //                         child: Center(
// //                           child: Text(
// //                             'signupPrompt',
// //                             textAlign: TextAlign.center,
// //                             style: Theme.of(context).textTheme.bodyText2,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //         ));
// //   }
// // }
