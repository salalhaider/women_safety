import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/screens/auth/login.dart';
import 'package:women_safety_app/screens/dashboard/dashboard_page.dart';
import 'package:women_safety_app/screens/dashboard/web_dashboard.dart';
import 'package:women_safety_app/utils/firebase_push_notification_service.dart';
import 'package:women_safety_app/utils/globals.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            saveDeviceToken();
            if(!kIsWeb) {
              initNotifs(context);
            }
            User _user = snapshot.data as User;
            if (_user.emailVerified) {
              return kIsWeb
                  ? WebDashboard(
                      userId: _user.uid,
                    )
                  : DashboardPage(
                      userId: _user.uid,
                    );
            } else {
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
                            Icons.error_outline,
                            size: 100,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Email not verified !',
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
                            'Please verify you email to continue',
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
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
