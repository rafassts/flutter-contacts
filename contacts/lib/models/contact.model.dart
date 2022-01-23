import 'package:contacts/settings.dart';

class ContactModel {
  int? id = 0;
  String name = "";
  String email = "";
  String phone = "";
  String image = DEFAULT_PROFILE_PICTURE_PATH;
  String addressLine1 = "";
  String addressLine2 = "";
  String latLng = "";

  ContactModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.addressLine1,
      required this.addressLine2,
      required this.latLng});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addresLine2'];
    latLng = json['latLng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['addressLine1'] = this.addressLine1;
    data['addresLine2'] = this.addressLine2;
    data['latLng'] = this.latLng;
    return data;
  }
}
