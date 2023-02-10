import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../models/CustomStorage.dart';
import '../widget/AppBar.dart';
import '../widget/Text.dart';

class FlashViewController extends GetxController{

  final MyAppController _myAppController = Get.put(MyAppController());

  late Timer timer;

  @override
  void onInit() async {
    super.onInit();
    timer = Timer(const Duration(seconds: 5), () async {
      if(_myAppController.connection.value && await networkCheck()){
        checkKeepMeLogin();
      }
      else{
        Get.offNamed("/offlinePage");
      }
    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  checkKeepMeLogin(){
    var remember = CustomStorage.getValue("remember");
    if(remember != null || remember == true){
      if(CustomStorage.getValue("user_id") != null){
        Get.offNamed("/homePage");
      }
      else{
        Get.offNamed("/loginPage");
      }
    }
    else{
      Get.offNamed("/loginPage");
    }
  }

  Future<bool> networkCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
      return true;
    }
    else{
      return false;
    }
  }
}

class FlashView extends StatelessWidget {

  final FlashViewController _flashViewController = Get.put(FlashViewController());

  FlashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 1.9),
        child: CustomAppBar(
          height: MediaQuery.of(context).size.height / 2.5,
          title: "Online ",
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CustomText(
                  text: "Services",
                  fontWeight: FontWeight.bold,
                  size: 25.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: CustomText(
                    text: "Waverley.",
                    size: 18.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Copyright © ${DateTime.now().year}",
                    size: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CustomText(
                        text: "App by",
                        size: 15.0,
                      ),
                      CustomText(
                        text: " ",
                        size: 15.0,
                        color: Colors.lightBlue,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
