import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/FlashView.dart';
import 'config/Routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp();
  await GetStorage.init();
  configPushNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  bool value = await FlutterAppBadger.isAppBadgeSupported();
  if(value){
    FlutterAppBadger.updateBadgeCount(1);
  }
}

void configPushNotification(){
  AwesomeNotifications().initialize(
    "resource://drawable/notification_logo",
    [
      NotificationChannel(
        channelKey: "",
        channelName: "Notifications",
        channelDescription: "Notification channel for ",
        importance: NotificationImportance.High,
        channelShowBadge: true,
        icon: "resource://drawable/notification_logo",
        defaultColor: const Color(0xFF89E14C),
        ledColor: const Color(0xFF89E14C)
      ),
    ],
  );
}

void cacheImages(BuildContext context){
  precacheImage(const AssetImage("assets/logo/logo.png"), context);
}

class MyAppController extends GetxController{

  var connection = true.obs;

  late var _connectivitySubscription;

  @override
  void onInit() {
    getLocationPermission();
    getConnectionStream();
    clearNotifications();
    super.onInit();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void clearNotifications() async {
    bool value = await FlutterAppBadger.isAppBadgeSupported();
    if(value){
      FlutterAppBadger.removeBadge();
    }
  }

  void getConnectionStream(){
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if((result == ConnectivityResult.wifi) || (result == ConnectivityResult.mobile)){
        connection.value = true;
      }
      else{
        connection.value = false;
      }
    });
  }

  Future<bool> checkLocationServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkPermissionIsEnable() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if((permission == LocationPermission.always) || (permission == LocationPermission.whileInUse)){
      return true;
    }
    else{
      return false;
    }
  }

  void getLocationPermission() async {
    if(await checkLocationServiceEnable()){
      if(!await checkPermissionIsEnable()){
        await Geolocator.requestPermission();
        getLocationPermission();
      }
    }
    else{
      await Geolocator.openLocationSettings();
      getLocationPermission();
    }
  }
}

class MyApp extends StatelessWidget {

  final MyAppController _myAppController = Get.put(MyAppController());

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cacheImages(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      getPages: Routes.routes,
      home: FlashView(),
    );
  }
}