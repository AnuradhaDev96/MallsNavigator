//Developed by
//IT17076494 - De Silva P.H.N.N
import 'package:cloud_firestore/cloud_firestore.dart';

class Mall {
  String name;
  String description;
  double longitude;
  double latitude;
  DocumentReference reference;

  Mall({this.name, this.description, this.longitude, this.latitude});

  Mall.fromMap(Map<String, dynamic> map, {this.reference}):
    //id = map["id"],
    name = map["name"],
    description = map["description"],
    longitude = map["longitude"],
    latitude = map["latitude"];

  
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };

  } 
  
  Mall.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson(){
    return {
      //'id': id,
      'name': name,
      'description': description,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}