// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mdi/mdi.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class SettingsPage extends StatefulWidget {
  User? user;
  SettingsPage({Key? key, this.user}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Map trusties = {};
  ValueNotifier<Map> trusties = ValueNotifier({});
  ValueNotifier<String> contactNumber = ValueNotifier('');
  ValueNotifier<String> defaultNumber = ValueNotifier('');
  Map emergencyNumbers = {};
  User? currentUser;
  GlobalKey<FormState>? formKey;
  GlobalKey<FormState>? trustyFormKey;
  bool isLoading = false;

  @override
  void initState() {
    formKey = GlobalKey();
    trustyFormKey = GlobalKey();
    print('*************** init manage trusties **********');
    currentUser = widget.user;
    if (currentUser?.trusties != null) {
      print('*************** not null **********');
      trusties.value = currentUser!.trusties!;
    }
    if (currentUser?.defaultTrusty != null) {
      print('*************** not null **********');
      defaultNumber.value = currentUser!.defaultTrusty!;
    }
    if (currentUser?.emergencyContacts != null) {
      print('*************** not null **********');
      emergencyNumbers = currentUser!.emergencyContacts!;
    }
    print('*************** $trusties **********');
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    trusties.notifyListeners();
    super.initState();
  }

  @override
  void dispose() {
    print('*********** dispose **********');
    // trusties.value = [];
    super.dispose();
  }

  getTrustyCard(Map trusty) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
              topLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.12))
            ]),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          color: const Color(0xFFFFFFFF),
          shadowColor: const Color(0x1F000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(4),
                ),
                color: Colors.blueGrey.shade100,
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x16000000),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.blueGrey.shade700,
                            size: 20,
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trusty['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                      fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              trusty['phoneNumber'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 32,
                      width: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          makePhoneCall(trusty['phoneNumber']);
                        },
                        child: Center(
                          child: Icon(
                            Icons.call,
                            color: Colors.blueGrey.shade700,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (defaultNumber.value == trusty['phoneNumber']) {
                          defaultNumber.value = '';
                          defaultNumber.notifyListeners();
                        } else {
                          defaultNumber.value = trusty['phoneNumber'];
                          defaultNumber.notifyListeners();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: ValueListenableBuilder(
                              valueListenable: defaultNumber,
                              builder: (context, number, _) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Mdi.cursorDefault,
                                      color: defaultNumber.value ==
                                              trusty['phoneNumber']
                                          ? Colors.red.shade300
                                          : Color(0xff757575),
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      defaultNumber.value ==
                                              trusty['phoneNumber']
                                          ? 'Remove Default'
                                          : 'Set Default',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: defaultNumber.value ==
                                                      trusty['phoneNumber']
                                                  ? Colors.red.shade300
                                                  : AppColors.primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                    )
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        showBottomSheet(trusty, true);
                      },
                      child: Container(
                        // padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        // color: Colors.white,
                        alignment: Alignment.center,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Colors.blueGrey,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Edit',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.blueGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }

  showBottomSheet(Map trusty, bool isEditForm) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
        builder: (context) {
          String? name, phoneNumber, relation;

          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: trustyFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Trusty',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        initialValue: isEditForm ? trusty['name'] : '',
                        label: 'Name',
                        hint: 'Enter name',
                        onSaved: (v) {
                          if (v != null) {
                            name = v.trim();
                          }
                        },
                        onValitdate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Name cannot be null';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder(
                          valueListenable: contactNumber,
                          builder: (context, number, _) {
                            print('sdjbfkjadbsg');
                            print(number);
                            return CustomTextField(
                              initialValue: contactNumber.value.isNotEmpty
                                  ? contactNumber.value
                                  : isEditForm
                                      ? trusty['phoneNumber']
                                      : '',
                              label: 'Phone Number',
                              hint: 'Enter phone number',
                              keyboardType: TextInputType.phone,
                              trailing: IconButton(
                                onPressed: () async {
                                  final PhoneContact contact =
                                      await FlutterContactPicker
                                              .pickPhoneContact()
                                          .then((value) {
                                    if (value.phoneNumber?.number != null) {
                                      // setContactState(() {
                                      contactNumber.value =
                                          value.phoneNumber!.number!;
                                      contactNumber.notifyListeners();
                                      // });
                                    }
                                    return value;
                                  });

                                  print(contact);
                                },
                                icon: const Icon(
                                  Icons.contact_page,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              onSaved: (v) {
                                if (v != null) {
                                  phoneNumber = v.trim();
                                }
                              },
                              onValitdate: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Phone cannot be null';
                                } else if (v.contains(RegExp(r'[a-z]'))) {
                                  return 'Phone number must contains number only';
                                } else if (v.length < 11) {
                                  return 'Phone number must contains 11 numbers';
                                } else {
                                  return null;
                                }
                              },
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      // StatefulBuilder(builder: (context, setTextFieldState) {
                      //   return TypeAheadFormField<String>(
                      //     suggestionsCallback: () async {
                      //       return Future.value(['']);
                      //     },
                      //     initialValue: isEditForm ? trusty['relation'] : '',
                      //     textFieldConfiguration: TextFieldConfiguration(
                      //         autofocus: true,
                      //         style: DefaultTextStyle.of(context)
                      //             .style
                      //             .copyWith(fontStyle: FontStyle.italic),
                      //         decoration: InputDecoration(
                      //             border: OutlineInputBorder())),
                      //     validator: (v) {
                      //       if (v == null || v.isEmpty) {
                      //         return 'Relation cannot be null';
                      //       } else {
                      //         return null;
                      //       }
                      //     },
                      //     onSaved: (v) {
                      //       if (v != null) {
                      //         relation = v.trim();
                      //       }
                      //     },
                      //     itemBuilder: (context, suggestion) {
                      //       return ListTile(
                      //         leading: const Icon(Icons.person),
                      //         title: Text(suggestion),
                      //       );
                      //     },
                      //     onSuggestionSelected: (suggestion) {
                      //       setTextFieldState(() {
                      //         relation = suggestion;
                      //       });
                      //     },
                      //   );
                      // }),
                      CustomTextField(
                        initialValue: isEditForm ? trusty['relation'] : '',
                        label: 'Relation',
                        hint: 'Enter relation with this trusty',
                        onSaved: (v) {
                          if (v != null) {
                            relation = v.trim();
                          }
                        },
                        onValitdate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Relation cannot be null';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (trustyFormKey!.currentState!.validate()) {
                                  trustyFormKey!.currentState!.save();
                                  print(trusties.value);
                                  if (isEditForm &&
                                      trusty['phoneNumber'] != phoneNumber) {
                                    trusties.value
                                        .remove(trusty['phoneNumber']);
                                  }

                                  trusties.value[phoneNumber] = {
                                    'name': name,
                                    'phoneNumber': phoneNumber,
                                    'relation': relation
                                  };
                                  print(trusties.value);
                                  trusties.notifyListeners();
                                  Navigator.pop(context);
                                }
                              },
                              child: !isLoading
                                  ? const SizedBox(
                                      width: 400,
                                      child: Center(child: Text('Add')))
                                  : const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          if (isEditForm)
                            const SizedBox(
                              width: 5,
                            ),
                          if (isEditForm)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () {
                                  trusties.value.remove(trusty['phoneNumber']);
                                  if (defaultNumber.value ==
                                      trusty['phoneNumber']) {
                                    defaultNumber.value = '';
                                  }
                                  trusties.notifyListeners();
                                  Navigator.pop(context);
                                },
                                child: !isLoading
                                    ? const SizedBox(
                                        width: 400,
                                        child: Center(child: Text('Delete')))
                                    : const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            // trusties.value = [];
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: StatefulBuilder(builder: (context, setBodyState) {
          return ElevatedButton(
            onPressed: () async {
              if (formKey!.currentState!.validate()) {
                formKey!.currentState!.save();
                setBodyState(() {
                  isLoading = true;
                });
                bool response = await userRepo
                    .setTrusties(currentUser!.id!, trusties.value,
                        emergencyNumbers, defaultNumber.value)
                    .then((value) {
                  setBodyState(() {
                    isLoading = false;
                  });
                  return value;
                });
                Fluttertoast.showToast(
                    msg: response ? 'Updated successfully' : 'Failed',
                    backgroundColor: Colors.white,
                    textColor: Colors.blueGrey);
                print(
                    '\n\n ------- trusties -------> ${trusties.value} \n\n\n');
                print(
                    '\n\n ------- emergency numbers -------> $emergencyNumbers \n\n\n');
                setBodyState(() {
                  isLoading = false;
                });
              }
            },
            child: !isLoading
                ? const Text('Save')
                : const SizedBox(
                    height: 15,
                    width: 15,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
          );
        }),
      ),
      body: WillPopScope(
        onWillPop: () {
          // trusties.value = [];
          Navigator.pop(context);
          return Future.delayed(const Duration(milliseconds: 0));
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage Trusties',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                    valueListenable: trusties,
                    builder: (context, trustiesMap, _) {
                      trustiesMap as Map;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: trustiesMap.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: getTrustyCard(trustiesMap[
                                  trustiesMap.keys.toList()[index]]),
                            );
                          });
                    }),
                ElevatedButton(
                    onPressed: () {
                      print('*************** $trusties **********');
                      // trusties.value.add('');
                      showBottomSheet({}, false);
                      // trusties.notifyListeners();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Add Trusty'),
                      ],
                    )),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage Emergency Contacts',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          initialValue: emergencyNumbers['police'] ?? '1111',
                          label: 'Police',
                          hint: 'Enter police number',
                          onSaved: (v) {
                            if (v != null) {
                              emergencyNumbers['police'] = v.trim();
                            }
                          },
                          onValitdate: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Number cannot be null';
                            } else if (v.contains(RegExp(r'[a-z]'))) {
                              return 'Field must contains number only';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          initialValue: emergencyNumbers['ambulance'] ?? '1111',
                          label: 'Ambulance',
                          hint: 'Enter ambulance number',
                          onSaved: (v) {
                            if (v != null) {
                              emergencyNumbers['ambulance'] = v.trim();
                            }
                          },
                          onValitdate: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Number cannot be null';
                            } else if (v.contains(RegExp(r'[a-z]'))) {
                              return 'Field must contains number only';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
