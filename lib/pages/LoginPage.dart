import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../repository/API.dart';
import '../models/CustomStorage.dart';
import '../config/Style.dart';
import '../models/User.dart';
import '../widget/AppBar.dart';
import '../widget/Button.dart';
import '../widget/LoadingProgress.dart';
import '../widget/PasswordField.dart';
import '../widget/Text.dart';
import '../widget/TextField.dart';

class LoginPageController extends GetxController{
  var showPassword = true.obs;

  var remember = false.obs;

  @override
  void onInit() async {
    clearUser();
    super.onInit();
  }

  togglePassword() => showPassword.value = showPassword.toggle().value;

  toggleKeepMeLog() => remember.value = remember.toggle().value;

  clearUser() async {
    if(CustomStorage.getValue("user_id") != null){
      await API.logout();
    }
  }
}

class LoginPage extends StatelessWidget {

  final LoginPageController _loginPageController = Get.put(LoginPageController());
  final MyAppController _myAppController = Get.put(MyAppController());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: CustomAppBar(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextField(
                    textInputType: TextInputType.emailAddress,
                    labelText: "Email",
                    textEditingController: _usernameController,
                    validate: (value){
                      if(GetUtils.isNullOrBlank(value)!){
                        return "Please Input Email";
                      }
                      else if(!GetUtils.isEmail(value!)){
                        return "Invalid Email";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Obx(() => CustomPasswordField(
                      labelText: "Password",
                      showPassword: _loginPageController.showPassword.value,
                      textEditingController: _passwordController,
                      passwordVisibility: _loginPageController.togglePassword,
                      validate: (value){
                        if(GetUtils.isNullOrBlank(value)!){
                          return "Please Input Password";
                        }
                        else if(GetUtils.isLengthLessThan(value, 8)){
                          return "Password too short";
                        }
                        return null;
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Radio(
                          value: _loginPageController.remember.value,
                          groupValue: true,
                          onChanged: (value) => _loginPageController.toggleKeepMeLog(),
                          toggleable: true,
                        )),
                        const CustomText(
                          text: "Keep me log",
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: CustomButton(
                      text: "SIGN IN",
                      color: Styles.themeColorLight,
                      radius: 10.0,
                      fontSize: 20.0,
                      textColor: Colors.white,
                      action: () async {
                        FocusScope.of(context).unfocus();
                        if(_key.currentState!.validate()){
                          Get.defaultDialog(
                            barrierDismissible: false,
                            title: "Checking...",
                            content: CustomLoadingProgress(Styles.themeColorLight),
                          );
                          String? fcmToken = await FirebaseMessaging.instance.getToken();
                          User user = User(email: _usernameController.text,password: _passwordController.text,fcm_token: fcmToken);
                          var result = await API.loginAdmin(user);
                          if((result is bool) && (result == false)){
                            Get.back();
                            Get.snackbar(
                              "Error",
                              "Invalid Username or Password",
                              backgroundColor: Colors.red,
                              icon: const Icon(Icons.clear),
                            );
                          }
                          else {
                            if(_loginPageController.remember.value){
                              CustomStorage.setValue("remember", true);
                            }
                            CustomStorage.setValue("user_id", result.id);
                            Get.back();
                            Get.offNamed("/homePage");
                          }
                        }
                        else{
                          if(Get.isSnackbarOpen){
                            Get.back();
                          }
                          else{
                            Get.snackbar(
                              "Error",
                              "Please Input Correct Details",
                              backgroundColor: Colors.red,
                              icon: const Icon(Icons.error),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
