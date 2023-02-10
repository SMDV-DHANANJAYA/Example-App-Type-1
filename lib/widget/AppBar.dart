import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../widget/Button.dart';
import '../widget/LoadingProgress.dart';
import '../repository/API.dart';
import '../config/Style.dart';
import 'Text.dart';

class CustomShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height-100);
    path.quadraticBezierTo(width/2, height + 20, width, height-100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomAppBar extends StatelessWidget{

  final double? height;
  final String? title;
  final bool? logout;

  const CustomAppBar({Key? key, this.height,this.title = "",this.logout = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      primary: true,
      automaticallyImplyLeading: true,
      leading: null,
      elevation: 0.0,
      title: CustomText(
        text: title,
        textAlign: TextAlign.center,
        size: 25.0,
        fontWeight: FontWeight.bold,
        letterSpace: 1,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Stack(
        children: [
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              color: Styles.themeColorLight,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 120,
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.all( Radius.elliptical(MediaQuery.of(context).size.width / 1.5, 120)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/logo/logo.png"),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: logout!,
          child: IconButton(
            onPressed: () async {
              Get.defaultDialog(
                title: "Confirm Logout?",
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
                      action: () async {
                        Get.back();
                        Get.defaultDialog(
                          barrierDismissible: false,
                          title: "Logging Out...",
                          content: CustomLoadingProgress(Styles.themeColorLight),
                        );
                        var result = await API.logout();
                        if(result){
                          Get.back();
                          Get.offNamed("/loginPage");
                        }
                        else {
                          Get.back();
                          Get.snackbar(
                            "!!! Error !!!",
                            "Try again later",
                            backgroundColor: Colors.red,
                            icon: const Icon(Icons.clear),
                          );
                        }
                      },
                    ),
                  ],
                ),
                backgroundColor: Styles.themeColorLight,
                radius: 10.0,
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
