import 'package:contacts/android/styles.dart';
import 'package:contacts/controllers/address.controller.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressView extends StatefulWidget {
  final ContactModel model;

  const AddressView({Key? key, required this.model}) : super(key: key);
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  var addressController = new AddressController();
  final ContactRepository _repository = new ContactRepository();

  @override
  void initState() {
    super.initState();
    if (widget.model.latLng != "") {
      var values = widget.model.latLng.split(','); //model vem string
      addressController.setCenter(
          double.parse(values[0]), double.parse(values[1]));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    addressController.setGoogleMapController(controller);
    addressController.setMapPosition(
        widget.model.addressLine2, widget.model.addressLine1);
    setState(() {});
  }

  onSearch(String address) async {
    await addressController.searchAddress(address).then((value) {
      widget.model.addressLine1 = value.addressLine1;
      widget.model.addressLine2 = value.addressLine2;
      widget.model.latLng = value.latLng;
      setState(() {});
    }).catchError((err) {});
  }

  updateContactAddress() async {
    await _repository
        .updateAddress(widget.model.id ?? 0, widget.model.addressLine1,
            widget.model.addressLine2, widget.model.latLng)
        .then((value) {
      onSuccess();
    }).catchError((err) {
      onError();
    });
  }

  setCurrentLocation() async {
    await addressController.setCurrentLocation().then((_) {
      setState(() {});
    });
  }

  onSuccess() {
    Navigator.pop(context);
  }

  onError() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Endereço",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: updateContactAddress,
            child: Icon(
              Icons.save,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            child: ListTile(
              isThreeLine: true,
              title: Text(
                "Endereço",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.addressLine1,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.model.addressLine2,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 80,
            child: TextField(
              decoration: InputDecoration(labelText: "Pesquisar...."),
              onSubmitted: (val) {
                onSearch(val);
              },
            ),
          ),
          Expanded(
            child: Container(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: addressController.markers,
                initialCameraPosition: CameraPosition(
                  target: addressController.getCenter(),
                  zoom: 11.0,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: setCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
