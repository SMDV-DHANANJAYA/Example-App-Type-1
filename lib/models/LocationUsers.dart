import 'User.dart';

class LocationUsers{
  String? job_status;
  User? user;

  LocationUsers({this.job_status, this.user});

  LocationUsers.fromJson(Map<String,dynamic> json){
    job_status = json["job_status"];
    user = User.fromJson(json["user"]);
  }
}