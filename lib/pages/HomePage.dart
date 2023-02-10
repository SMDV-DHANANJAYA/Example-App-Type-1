import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../pages/section/LocationPage.dart';
import '../models/User.dart';
import '../models/CustomStorage.dart';
import '../repository/API.dart';
import '../config/Style.dart';
import '../widget/AppBar.dart';
import '../widget/BottomNavBar.dart';
import '../widget/Button.dart';
import '../pages/section/MapPage.dart';

class HomePageController extends GetxController{

  var loadingProfile = true.obs;

  User user = User();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    getUser();
    getNotificationService();
    super.onInit();
  }

  void getUser(){
    loadingProfile.value = true;
    API.getUser().then((value){
      if((value is bool) && (value == false)){
        CustomStorage.deleteValue("user_id");
        CustomStorage.deleteValue("remember");
        CustomStorage.deleteValue("access_token");
        CustomStorage.deleteAll();
        Get.offNamed("/loginPage");
      }
      else{
        user = value;
      }
      loadingProfile.value = false;
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    if(CustomStorage.getValue("access_token") != null){
      await API.changeFCMToken(token);
    }
  }

  getNotificationService() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: DateTime.now().second,
            channelKey: "",
            title: message.notification?.title,
            body: message.notification?.body,
            notificationLayout: NotificationLayout.BigText,
            wakeUpScreen: true,
            displayOnBackground: true,
            displayOnForeground: true
        ),
      );
    });
  }
}

class HomePage extends StatelessWidget {

  final HomePageController _homePageController = Get.put(HomePageController());

  final CustomBottomNavBarController _navBarController = Get.put(CustomBottomNavBarController());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Get.defaultDialog(
          title: "Confirm Exit?",
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: "No",
                color: Colors.white,
                textColor: Colors.black,
                radius: 10.0,
                action: (){
                  Get.back();
                },
              ),
              CustomButton(
                text: "Yes",
                color: Colors.red,
                textColor: Colors.black,
                radius: 10.0,
                action: (){
                  Get.back();
                  SystemNavigator.pop(animated: true);
                },
              ),
            ],
          ),
          backgroundColor: Styles.themeColorLight,
          radius: 10.0,
        );
        return false as Future<bool>;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: CustomAppBar(logout: true),
        ),
        body: Obx(() => IndexedStack(
          index: _navBarController.index.value,
          children: [
            MapPage(),
            LocationPage(),
          ],
        )),
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}