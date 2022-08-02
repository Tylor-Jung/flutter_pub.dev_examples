import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_package/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _showToast();
            },
            child: const Text('button'),
          ),
          ElevatedButton(
            onPressed: () async {
              final notification = flutterLocalNotificationsPlugin;

              const android = AndroidNotificationDetails(
                '0',
                '알림 테스트',
                channelDescription: '알림 테스트 바디부분',
                importance: Importance.max,
                priority: Priority.max,
              );
              const ios = IOSNotificationDetails();
              const detail = NotificationDetails(
                android: android,
                iOS: ios,
              );

              final permission = Platform.isAndroid
                  ? true
                  : (await notification
                          .resolvePlatformSpecificImplementation<
                              IOSFlutterLocalNotificationsPlugin>()
                          ?.requestPermissions(
                              alert: true, badge: true, sound: false) ??
                      false);
              print('permission $permission');
              if (!permission) {
                return;
              }
              await flutterLocalNotificationsPlugin.show(
                0,
                'plain title',
                'plain body',
                detail,
              );
            },
            child: const Text('add alram'),
          ),
          const Center(
            child: Text('hi'),
          ),
        ],
      ),
    );
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("show toast"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }
}
