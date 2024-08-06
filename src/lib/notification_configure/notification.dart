import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lookout_dev/screen/info_screen/event_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/main.dart';
import 'notification_button.dart';

class NotificationService {
  final _firebaseMsg = FirebaseMessaging.instance;

  static Future<void> initNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelGroupKey: 'high_importance_channel',
          channelName: 'Lol',
          channelDescription: 'lmao',
          defaultColor: Colors.black,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
       )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'high_importance_channel_group',
            channelGroupName: 'Group 0'
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed){
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification
  ) async {
    debugPrint('onNotiCreateMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification
      ) async {
    debugPrint('onNotiDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification
      ) async {
    debugPrint('onDismissActionMethod');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification
      ) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedNotification.payload ?? {};
    if (payload["navigate"] == "true"){
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const EventScreen(eventName: '123')),
      );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final DateTime? scheduledTime
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduledTime != null
        ? NotificationCalendar.fromDate(date: scheduledTime, preciseAlarm: true) : null,
    );
  }

}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Colors.grey[200]!,
              ],
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TopBar(title: 'Awesome Notification'),
            NotificationButton(
              text: "Normal Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                );
              },
            ),
            NotificationButton(
              text: "Notification With Summary",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.Inbox,
                );
              },
            ),
            NotificationButton(
              text: "Progress Bar Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.ProgressBar,
                );
              },
            ),
            NotificationButton(
              text: "Message Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.Messaging,
                );
              },
            ),
            NotificationButton(
              text: "Big Image Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Title of the notification",
                  body: "Body of the notification",
                  summary: "Small Summary",
                  notificationLayout: NotificationLayout.BigPicture,
                  bigPicture:
                  "https://files.tecnoblog.net/wp-content/uploads/2019/09/emoji.jpg",
                );
              },
            ),
            NotificationButton(
              text: "Action Buttons Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                    title: "Title of the notification",
                    body: "Body of the notification",
                    payload: {
                      "navigate": "true",
                    },
                    actionButtons: [
                      NotificationActionButton(
                        key: 'check',
                        label: 'Check it out',
                        actionType: ActionType.SilentAction,
                        color: Colors.green,
                      )
                    ]);
              },
            ),
            NotificationButton(
              text: "Scheduled Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Scheduled Notification",
                  body: "Notification was fired after 1 seconds from ${DateTime.now().add(const Duration(seconds: 1))}",
                  scheduledTime: DateTime.now().add(const Duration(seconds: 1)),
                );
              },
            ),

            NotificationButton(
              text: "Scheduled Notification",
              onPressed: () async {
                await NotificationService.showNotification(
                  title: "Scheduled Notification",
                  body: "Notification was fired after 30 minutes from ${DateTime.now().add(const Duration(minutes: 30))}",
                  scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}