import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';

showNotificationAlert(BuildContext context) {
    String title = '', body = '';
    ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
    final formKey = GlobalKey<FormState>();
    
    Alert(
        context: context,
        title: "Send Notification",
        content: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Title',
                    hint: 'Enter Title',
                    onSaved: (v) {
                      title = v!;
                    },
                    onValitdate: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Title cannot be null';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'Detail',
                    hint: 'Enter Details',
                    maxLines: 4,
                    onSaved: (v) {
                      body = v!;
                    },
                    onValitdate: (v) {
                      // if (v == null || v.isEmpty) {
                      //   return 'Title cannot be null';
                      // } else {
                      return null;
                      // }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                userRepo.sendNotificationToAll(title, body);
                Navigator.pop(context);
              }
            },
            child: ValueListenableBuilder(
                valueListenable: isLoadingNotifier,
                builder: (context, isLoading, _) {
                  return isLoading == false
                      ? const Text(
                          'Send',
                          style: TextStyle(color: Colors.white),
                        )
                      : const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                }),
          ),
        ]).show();
  }
