//Developed by
//IT17006408 - A.S.H. Siribaddana
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteMall {
  String name;
  String description;
  double longitude;
  double latitude;
  DocumentReference userId; 
  DocumentReference mallId;
  DocumentReference reference;

  FavouriteMall({this.name, this.description, this.longitude, this.latitude, this.userId, this.mallId});

  FavouriteMall.fromMap(Map<String, dynamic> map, {this.reference}):
    name = map["name"],
    description = map["description"],
    longitude = map["longitude"],
    latitude = map["latitude"],
    userId = map["userId"],
    mallId = map["mallId"];

  
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'userId': userId,
      'mallId': mallId
    };

  } 
  
  FavouriteMall.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson(){
    return {
      'name': name,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'userId': userId,
      'mallId': mallId
    };
  }
}