import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/dashboard_page.dart';
import 'package:women_safety_app/screens/dashboard/web_dashboard.dart';
import 'package:women_safety_app/screens/profile/custom_notification_alert.dart';
import 'package:women_safety_app/screens/profile/manage_users.dart';
import 'package:women_safety_app/screens/profile/profile_screen.dart';
import 'package:women_safety_app/screens/orders/manage_orders.dart';
import 'package:women_safety_app/screens/store/store_screen.dart';
import 'package:women_safety_app/screens/videos/video_screen.dart';
import 'package:women_safety_app/utils/globals.dart';

class CustomWebDrawer extends StatefulWidget {
  User? currentUser;
  CustomWebDrawer({Key? key,this.currentUser}) : super(key: key);

  @override
  State<CustomWebDrawer> createState() => _CustomWebDrawerState();
}

class _CustomWebDrawerState extends State<CustomWebDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.blueGrey,
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
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                        builder: (context) => WebDashboard(
                              userId: widget.currentUser!.id,
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
                              user: widget.currentUser,
                            )));
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Manage Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StoreScreen()));
              },
              leading: const Icon(Icons.store),
              title: const Text('Manage Store'),
            ),
            // ListTile(
            //   onTap: () {},
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Settings'),
            // ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoScreen()));
              },
              leading: const Icon(Icons.play_arrow),
              title: const Text('Manage Videos'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageOrdersScreen()));
              },
              leading: const Icon(Mdi.cartArrowUp),
              title: const Text('Manage Orders'),
            ),
            ListTile(
              onTap: () => showNotificationAlert(context),
              leading: const Icon(Icons.notification_add),
              title: const Text('Send Notification'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageUsersScreen()));
              },
              leading: const Icon(Icons.person),
              title: const Text('Manage Users'),
            ),
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
    );
  }
}
