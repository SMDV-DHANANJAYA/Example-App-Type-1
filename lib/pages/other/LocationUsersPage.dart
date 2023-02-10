import 'package:flutter/material.dart';
import '../../models/LocationUsers.dart';
import '../../config/Style.dart';
import '../../repository/API.dart';
import '../../widget/AppBar.dart';
import 'package:get/get.dart';
import '../../widget/LoadingProgress.dart';
import '../../widget/Text.dart';

class LocationUsersPage extends StatelessWidget {
  LocationUsersPage({Key? key}) : super(key: key);

  int locationId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: CustomAppBar(),
      ),
      body: FutureBuilder(
        future: API.getLocationUsers(locationId),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<LocationUsers> locationUsers = snapshot.data as List<LocationUsers>;
            if(locationUsers.isNotEmpty){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: locationUsers.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      tileColor: locationUsers[index].job_status == "late" ? Colors.red : Colors.white,
                      title: CustomText(
                        text: locationUsers[index].user!.full_name,
                        fontWeight: FontWeight.bold,
                        color: locationUsers[index].job_status == "late" ? Colors.white : Colors.black,
                      ),
                      trailing: CustomText(
                        text: locationUsers[index].user!.mobile ?? "-",
                        color: locationUsers[index].job_status == "late" ? Colors.white : Colors.black,
                      ),
                      subtitle: CustomText(
                        text: locationUsers[index].user!.email ?? "",
                        color: locationUsers[index].job_status == "late" ? Colors.white : Colors.black,
                      ),
                    );
                  },
                  separatorBuilder: (context, index){
                    return const Divider(
                      endIndent: 15,
                      indent: 15,
                      thickness: 2,
                      height: 0,
                    );
                  },
                ),
              );
            }
            else{
              return const Center(
                child: CustomText(
                  text: "There are no users assigned to this location.",
                ),
              );
            }
          }
          return Center(child: CustomLoadingProgress(Styles.themeColorLight));
        },
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}
