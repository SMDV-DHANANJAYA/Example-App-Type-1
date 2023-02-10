import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/Style.dart';
import 'IconButton.dart';

class CustomBottomNavBarController extends GetxController{
  var index = 1.obs;

  changeIndex(int value){
    if(index.value != value){
      index.value = value;
    }
  }
}

class CustomBottomNavBar extends StatelessWidget {

  final CustomBottomNavBarController _customBottomNavBarController = Get.put(CustomBottomNavBarController());

  CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      decoration:  BoxDecoration(
        color: Styles.themeColorLight,
        borderRadius:  const BorderRadius.vertical(top: Radius.elliptical(300, 50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => CustomIconButton(
            icon: _customBottomNavBarController.index.value == 0 ? Icons.location_on : Icons.location_on_outlined,
            size: _customBottomNavBarController.index.value == 0 ? 35.0 : 30.0,
            color: _customBottomNavBarController.index.value == 0 ? Colors.black : Colors.white,
            action: () => _customBottomNavBarController.changeIndex(0),
          )),
          Obx(() => CustomIconButton(
            icon: _customBottomNavBarController.index.value == 1 ? Icons.home : Icons.home_outlined,
            size: _customBottomNavBarController.index.value == 1 ? 35.0 : 30.0,
            color: _customBottomNavBarController.index.value == 1 ? Colors.black : Colors.white,
            action: () => _customBottomNavBarController.changeIndex(1),
          )),
        ],
      ),
    );
  }
}
