class Location{
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? address;

  Location({this.id, this.name, this.latitude, this.longitude, this.address});

  Location.fromJson(Map<String,dynamic> json){
    id = int.parse(json["id"]);
    name = json["name"];
    latitude = double.parse(json["latitude"]);
    longitude = double.parse(json["longitude"]);
    address = json["address"];
  }
}