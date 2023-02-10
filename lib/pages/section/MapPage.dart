import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/Config.dart';
import '../../config/Style.dart';
import '../../main.dart';
import '../../models/Location.dart';
import '../../widget/GoogleMap.dart';
import '../../widget/LoadingProgress.dart';

class MapPageController extends GetxController{
  List<Marker> markers = <Marker>[].obs;

  late GoogleMapController googleMapController;

  var showMyLocationButton = true.obs;

  void changeMyLocationButtonVisibility(bool value){
    showMyLocationButton.value = value;
  }

  void addMarkers(List<Location> locations){
    if(markers.isNotEmpty){
      markers.clear();
    }
    for (var location in locations) {
      markers.add(Marker(
          markerId: MarkerId(location.id.toString()),
          infoWindow: InfoWindow(
            title: location.name,
            onTap: (){
              Get.toNamed("/locationUsersPage",arguments: location.id);
            }
          ),
          draggable: false,
          position: LatLng(location.latitude!,location.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
  }

  void moveToLocation(LatLng location){
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 16,
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {

  final MapPageController _mapPageController = Get.put(MapPageController());
  final MyAppController _myAppController = Get.put(MyAppController());

  MapPage({Key? key}) : super(key: key);

  Future<Position> getLocationData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Obx(() => SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomGoogleMap(
              mapCreate: (GoogleMapController mapController){
                _mapPageController.googleMapController = mapController;
              },
              cameraPosition: CameraPosition(
                target: LatLng(double.parse(Config.INITIAL_MAP_LATITUDE),double.parse(Config.INITIAL_MAP_LONGITUDE)),
                zoom: 8,
              ),
              markers: Set.from(_mapPageController.markers),
            ),
          )),
          Obx(() => Positioned.fill(
            bottom: (MediaQuery.of(context).size.height / 9) + 10,
            right: 20.0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: _mapPageController.showMyLocationButton.value ?
              FloatingActionButton(
                heroTag: "locationBtn",
                backgroundColor: Styles.themeColorLight,
                onPressed: (){
                  try{
                    _mapPageController.changeMyLocationButtonVisibility(false);
                    getLocationData().then((value){
                      _mapPageController.googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(value.latitude,value.longitude),
                            zoom: 16,
                          ),
                        ),
                      );
                      _mapPageController.changeMyLocationButtonVisibility(true);
                    });
                  }
                  catch(e){
                    _mapPageController.changeMyLocationButtonVisibility(true);
                    _myAppController.getLocationPermission();
                  }
                },
                child: const Icon(Icons.my_location,color: Colors.red,),
              ):
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0,right: 2.0),
                child: CustomLoadingProgress(Styles.themeColorLight),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
