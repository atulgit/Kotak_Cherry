import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AppConstants.dart';

mixin NotificationManager {
  static Future<void> scheduleNotification(String taskName, String taskSummary, DateTime scheduleDateTime) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = true; //await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: AppConstants.NOTFICATION_CHANNEL_KEY,
            title: taskName,
            body: taskSummary,
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            notificationLayout: NotificationLayout.Default,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(key: 'DISMISS', label: 'Dismiss', buttonType: ActionButtonType.Default)
        ],
        schedule: NotificationCalendar.fromDate(date: scheduleDateTime));
  }

  static void initLocalNotifications() {
    AwesomeNotifications().initialize(AppConstants.NOTIFICATION_ICON, [
      NotificationChannel(
        playSound: true,
        onlyAlertOnce: true,
        channelKey: AppConstants.NOTFICATION_CHANNEL_KEY,
        channelName: AppConstants.NOTFICATION_CHANNEL_NAME,
        channelDescription: 'Notification channel for tasks',
        channelShowBadge: true,
        groupAlertBehavior: GroupAlertBehavior.Children,
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Private,
        defaultColor: Colors.deepPurple,
        enableVibration: true,
      ),
    ]);
  }

  static Future<void> showLocalNotification() async {
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        //simgple notification
        id: 123,
        notificationLayout: NotificationLayout.Inbox,
        channelKey: 'basic',
        //set configuration wuth key "basic"
        title: 'Welcome to FlutterCampus.com',
        body: 'This simple notification is from Flutter App',
      ));
    }
  }
}
