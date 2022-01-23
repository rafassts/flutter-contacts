import 'package:contacts/models/addressDTO.model.dart';
import 'package:contacts/repositories/address.repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class AddressController {
  var markers = new Set<Marker>();
  late GoogleMapController mapController;
  var _center = new LatLng(45.521563, -122.677433);
  final _repository = new AddressRepository();

  setCenter(double lat, double lng) {
    _center = new LatLng(lat, lng);
  }

  setGoogleMapController(GoogleMapController controller) {
    mapController = controller;
  }

  getCenter() {
    return _center;
  }

  Future<AddressViewModel> searchAddress(String address) async {
    var addressViewModel = new AddressViewModel(
      addressLine1: "",
      addressLine2: "",
      latLng: "",
    );

    await _repository.searchMockAddress(address).then((position) {
      _center = LatLng(position['lat'], position['lng']);

      setMapPosition(position['addressLine2'], position['addressLine1']);

      addressViewModel = new AddressViewModel(
          addressLine1: position['addressLine1'],
          addressLine2: position['addressLine2'],
          latLng: "${position['lat']} , ${position['lng']}");
    }).catchError((err) {});
    return addressViewModel;
  }

  setMapPosition(title, snippet) {
    //atualiza a camera
    mapController.animateCamera(CameraUpdate.newLatLng(_center));
    markers = new Set<Marker>(); //zera toda a vez para ter só 1 marker
    var marker = createMarker(_center, title, snippet);
    markers.add(marker);
  }

  createMarker(LatLng position, String title, String snippet) {
    return new Marker(
      markerId: MarkerId(new Uuid().v4()),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );
  }

  setCurrentLocation() async {
    markers = new Set<Marker>(); //zera toda a vez para ter só 1 marker
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _center = new LatLng(position.latitude, position.longitude);
    setMapPosition("Posição Atual", "Localzação");
  }
}
