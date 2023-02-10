import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/CustomStorage.dart';
import '../../config/Style.dart';
import '../../models/Location.dart';
import '../../repository/API.dart';
import '../../widget/BottomNavBar.dart';
import '../../widget/Button.dart';
import '../../widget/IconButton.dart';
import '../../widget/LoadingProgress.dart';
import '../../widget/Text.dart';
import 'MapPage.dart';

class LocationPageController extends GetxController{
  var loadingLocation = true.obs;

  List<Location> locations = <Location>[].obs;

  var isStopTimer = false.obs;

  final MapPageController _mapPageController = Get.find();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    isStopTimer.value = true;
    super.onClose();
  }

  void getLocations(){
    API.getLocations().then((value){
      locations.clear();
      if(value != null){
        locations.addAll(value);
        _mapPageController.addMarkers(locations);
      }
      loadingLocation.value = false;
    });
  }

  void getData() {
    if(CustomStorage.getValue("access_token") != null){
      getLocations();
      Timer.periodic(const Duration(seconds: 20), (timer) {
        if (isStopTimer.value) {
          timer.cancel();
        }
        getLocations();
      });
    }
  }
}

class LocationPage extends StatelessWidget {

  final LocationPageController _locationPageController = Get.put(LocationPageController());

  final CustomBottomNavBarController _customBottomNavBarController = Get.find();

  final MapPageController _mapPageController = Get.find();

  LocationPage({Key? key}) : super(key: key);

  Widget locationListItem(Location location){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: ListTile(
        leading: CustomIconButton(
          icon: Icons.location_on,
          size: 40.0,
          color: Styles.themeColorLight,
          action: (){
            _customBottomNavBarController.changeIndex(0);
            _mapPageController.moveToLocation(LatLng(location.latitude!,location.longitude!));
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: location.name,
                fontWeight: FontWeight.bold,
                size: 20.0,
                resize: true,
                maxLines: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: CustomText(
                  text: location.address,
                  size: 15.0,
                  resize: true,
                  maxLines: 3,
                ),
              )
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Stack(
                  children: [
                    const Divider(
                      thickness: 3,
                      height: 40.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        text: "View Location",
                        radius: 20.0,
                        textColor: Colors.white,
                        color: Styles.themeColorLight,
                        action: (){
                          Get.toNamed("/locationUsersPage",arguments: location.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => _locationPageController.loadingLocation.value ?
      SizedBox(
        height: 50.0,
        width: 50.0,
        child: CustomLoadingProgress(Styles.themeColorLight),
      ) :
      _locationPageController.locations.isEmpty ?
      const CustomText(
        text: "You don't currently have locations.",
        size: 20.0,
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          itemCount: _locationPageController.locations.length,
          itemBuilder: (BuildContext context, int index){
            Location location = _locationPageController.locations[index];
            return locationListItem(location);
          },
        ),
      ),
      ),
    );
  }
}
