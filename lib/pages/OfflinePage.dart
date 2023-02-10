import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/Style.dart';
import '../widget/AppBar.dart';
import '../widget/LoadingProgress.dart';
import '../widget/Text.dart';

import 'FlashView.dart';

class OfflinePageController extends GetxController{

  final FlashViewController _flashViewController = Get.put(FlashViewController());

  var loading = false.obs;

  checkConnection(int duration) async {
    loading.value = true;
    bool netConnection = await _flashViewController.networkCheck();
    Timer(Duration(seconds: duration), () {
      if(netConnection){
        _flashViewController.checkKeepMeLogin();
      }
      loading.value = false;
    });
  }
}

class OfflinePage extends StatelessWidget {

  final OfflinePageController _offlinePageController = Get.put(OfflinePageController());

  OfflinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: CustomAppBar(),
      ),
      body: Center(
        child: Obx(() => _offlinePageController.loading.value ?
        SizedBox(
          height: 50.0,
          width: 50.0,
          child: CustomLoadingProgress(Styles.themeColorLight),
        ):
        GestureDetector(
          onTap: (){
            _offlinePageController.checkConnection(3);
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(
                  text: "!! Connection Error !!",
                  size: 30.0,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.themeColorLight,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                      child: CustomText(
                        text: "Try Again",
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
