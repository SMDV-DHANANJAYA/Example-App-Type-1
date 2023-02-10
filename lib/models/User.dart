class User{

  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? mobile;
  String? password;

  String? fcm_token;
  String? full_name;

  User({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.mobile,
    this.password,
    this.fcm_token,
    this.full_name,
  });

  User.fromJson(Map<String,dynamic> json){
    id = int.parse(json["id"]);
    first_name = json["first_name"];
    last_name = json["last_name"];
    email = json["email"];
    mobile = json["mobile"];
    full_name = json["full_name"];
  }
}