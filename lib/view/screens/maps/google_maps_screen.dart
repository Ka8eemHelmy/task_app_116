import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Position? position;

  Future<void> getCurrentLocation () async {
    position = await _determinePosition();
    // position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
    // _kGooglePlex.target = LatLng(position?.latitude ?? 0, position?.longitude ?? 0);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 5,
  );

  void trackking () {
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
              print('Changed');
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
          setState(() {
            this.position = position;
          });
              _goToTheLake(position?.heading ?? 0);
        });
  }

  @override
  void initState () {
    super.initState();
    getCurrentLocation();
    trackking();
  }

  Future<void> _goToTheLake(double heading) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: heading,
      target: LatLng(position?.latitude ?? 37.43296265331129, position?.longitude ?? -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(position?.latitude ?? 37.42796133580664, position?.longitude ?? -122.085749655962),
            zoom: 15,
          ),
          markers: <Marker>{
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(37.42796133580664, -122.085749655962),
              infoWindow: const InfoWindow(title: 'Googleplex'),
              icon: BitmapDescriptor.defaultMarker,
            ),
          },
          onTap: (LatLng latLng) {
            print(latLng);
          },
          polygons: <Polygon>{
            Polygon(
              polygonId: PolygonId('1'),
              points: <LatLng>[
                LatLng(37.42832822581767, -122.08662841469051),
                LatLng(37.428370292917386, -122.08580262959003),
                LatLng(37.42778827385659, -122.08430461585522),
                LatLng(37.42522877403065, -122.08627335727215),
              ],
              fillColor: Colors.blue.withOpacity(0.5),
              strokeColor: Colors.blue,
              strokeWidth: 2,
            ),
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // onPressed: _goToTheLake(),
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
}
