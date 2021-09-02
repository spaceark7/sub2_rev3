import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/ui/settings_screen.dart';
import 'package:pickeat/widgets/platformWidget.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = '/profile_page';

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Your Favorite Places', style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black))),
        child: _buildList(context));
  }
}

Widget _buildList(BuildContext context) {
  return SafeArea(
      child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Text(
                  "Username",
                  style: Theme.of(context).textTheme.bodyText1!.apply(fontSizeDelta: 10, fontWeightDelta: 5, letterSpacingDelta: 2),
                ),
                Text(
                  "This is your profile",
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            Container(height: 100, child: Image.asset('assets/avatar.png'))
          ],
        ),
        SizedBox(
          height: 50,
        ),
        InkWell(
          onTap: () {
            
             defaultTargetPlatform == TargetPlatform.iOS
                                          ? showCupertinoDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Coming Soon!'),
                                                  content: Text('This feature will be coming soon!'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Coming Soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5, fontSizeDelta: 5),
                                                  ),
                                                  content: Text(
                                                    'This feature will be coming soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: secondaryBrandColor),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Dismiss'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Change Username",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1))),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {

             defaultTargetPlatform == TargetPlatform.iOS
                                          ? showCupertinoDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Coming Soon!'),
                                                  content: Text('This feature will be coming soon!'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Coming Soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5, fontSizeDelta: 5),
                                                  ),
                                                  content: Text(
                                                    'This feature will be coming soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: secondaryBrandColor),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Dismiss'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Change Password",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Get.toNamed(SettingsScreen.routeName);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Settings",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
