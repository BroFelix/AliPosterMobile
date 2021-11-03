import 'dart:io';

import 'package:ali_poster/data/prefs/shared_preferences.dart';
import 'package:ali_poster/ui/auth/login.dart';
import 'package:ali_poster/ui/main/home.dart';
import 'package:ali_poster/ui/splash/splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp _app = await Firebase.initializeApp();
  runApp(MyApp(app: _app));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.app,
  }) : super(key: key);

  final FirebaseApp app;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  late FirebaseDatabase _cloudDatabase;
  final FirebaseMessaging _cloudMessaging = FirebaseMessaging.instance;
  final List<Notification> _notifications = [];
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  void _iOSPermission() {
    _cloudMessaging.requestPermission(alert: true, sound: true, badge: true);
  }

  Future<void> _firebaseCloudMessagingListeners() async {
    NotificationSettings settings = await _cloudMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _cloudMessaging.getNotificationSettings();
    // _messaging.requestPermission(alert: true, sound: true, badge: true);
    if (Platform.isIOS) _iOSPermission();
    await _cloudMessaging.setForegroundNotificationPresentationOptions(
      sound: true,
      alert: true,
      badge: true,
    );

    await _cloudMessaging.getToken().then((token) async {
      print(token);
      await setFCMToken(token!);
    });

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   try {
    //     print('Handling a background message: ${message.messageId}');
    //   } catch (e) {
    //     print(e.toString());
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title!,
            notification.body!,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
  }

  @override
  void initState() {
    _cloudDatabase = FirebaseDatabase(app: widget.app);
    _cloudDatabase.setPersistenceEnabled(true);
    _cloudDatabase.setPersistenceCacheSizeBytes(10000000);
    _firebaseCloudMessagingListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _cloudDatabase,
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        title: 'Flutter Demo',
        routes: {
          HomePage.route: (context) => const HomePage(),
          LoginPage.route: (context) => const LoginPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
