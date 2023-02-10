import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:odel_fs_admin/models/LocationUsers.dart';
import '../models/Location.dart';
import '../config/Config.dart';
import '../models/CustomStorage.dart';
import '../pages/FlashView.dart';
import '../models/User.dart';

class API{

  static final dio = Dio();

  static final FlashViewController _flashViewController = getx.Get.find();

  static redirectError(DioError e) async {
    log(e.message);
    bool value  = await _flashViewController.networkCheck();
    if(!value){
      getx.Get.offNamed("/offlinePage");
    }
  }

  static loginAdmin(User user) async {
    try{
      var response = await dio.post(
        Config.BASE_URL + Config.LOGIN_ADMIN,
        data: {
          "email" : user.email,
          "password" : user.password,
          "fcm_token" : user.fcm_token
        },
        options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
            headers: {
              "x-api-key" : Config.API_KEY
            }
        ),
      );
      if(response.statusCode == 200){
        CustomStorage.setValue("access_token", response.data["access_token"]);
        return User.fromJson(response.data["data"]);
      }
      else{
        return false;
      }
    }
    on DioError catch (e) {
      redirectError(e);
      return false;
    }
  }

  static getLocations() async {
    try{
      String? token = CustomStorage.getValue("access_token");
      if(token != null){
        var response = await dio.get(
          Config.BASE_URL + Config.GET_LOCATIONS,
          options: Options(
              contentType: "application/json",
              responseType: ResponseType.json,
              headers: {
                "x-api-key" : Config.API_KEY,
                "Authorization" : "Bearer $token",
              }
          ),
        );

        if(response.statusCode == 200){
          var locationsMap = response.data['data'];
          List<Location> locations = [];
          for (var location in locationsMap) {
            locations.add(Location.fromJson(location));
          }
          return locations;
        }
      }
      return null;
    }
    on DioError catch (e) {
      redirectError(e);
      return null;
    }
  }

  static changeFCMToken(String fcmToken) async {
    try{
      String token = CustomStorage.getValue("access_token");
      var response = await dio.put(
        Config.BASE_URL + Config.CHANGE_FCM_TOKEN,
        data: {
          "fcm_token" : fcmToken
        },
        options: Options(
          contentType: "application/json",
          responseType: ResponseType.json,
          headers: {
            "x-api-key" : Config.API_KEY,
            "Authorization" : "Bearer $token",
          },
        ),
      );
      if(response.statusCode == 200){
        return true;
      }
      else{
        return false;
      }
    }
    on DioError catch (e) {
      redirectError(e);
      return false;
    }
  }

  static logout() async {
    try{
      String token = CustomStorage.getValue("access_token");
      var response = await dio.post(
        Config.BASE_URL + Config.LOGOUT,
        options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
            headers: {
              "x-api-key" : Config.API_KEY,
              "Authorization" : "Bearer $token",
            }
        ),
      );
      if(response.statusCode == 200){
        CustomStorage.deleteValue("user_id");
        CustomStorage.deleteValue("remember");
        CustomStorage.deleteValue("access_token");
        CustomStorage.deleteAll();
        return true;
      }
      else{
        return false;
      }
    }
    on DioError catch (e) {
      redirectError(e);
      return false;
    }
  }

  static getUser() async {
    try{
      String token = CustomStorage.getValue("access_token");
      var response = await dio.get(
        Config.BASE_URL + Config.GET_USER_DATA,
        options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
            headers: {
              "x-api-key" : Config.API_KEY,
              "Authorization" : "Bearer $token",
            }
        ),
      );
      if(response.statusCode == 200){
        return User.fromJson(response.data["data"]);
      }
      else{
        return false;
      }
    }
    on DioError catch (e) {
      redirectError(e);
      return false;
    }
  }

  static getLocationUsers(int locationID) async {
    try{
      String token = CustomStorage.getValue("access_token");
      var response = await dio.get(
        Config.BASE_URL + Config.GET_LOCATION_USERS_1 + locationID.toString() + Config.GET_LOCATION_USERS_2,
        options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
            headers: {
              "x-api-key" : Config.API_KEY,
              "Authorization" : "Bearer $token",
            }
        ),
      );
      if(response.statusCode == 200){
        var locationUserMap = response.data['data'];
        List<LocationUsers> locationUsers = [];
        for (var locationUser in locationUserMap) {
          locationUsers.add(LocationUsers.fromJson(locationUser));
        }
        return locationUsers;
      }
      else{
        return false;
      }
    }
    on DioError catch (e) {
      redirectError(e);
      return false;
    }
  }

}