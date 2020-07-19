//Developed by
//IT17006408 - A.S.H. Siribaddana
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String fullName;
  String email;
  String password;
  String type;
  String profileImageUrl;
  DocumentReference reference;

  User({this.fullName, this.email, this.password, this.type, this.profileImageUrl});  

  User.fromMap(Map<String, dynamic> map, {this.reference}):
    fullName = map["fullName"],
    email = map["email"],
    password = map["password"],
    type = map["type"],
    profileImageUrl = map["profileImageUrl"];
  
  Map<String, dynamic> toMap(){
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'type': type,
      'profileImageUrl': profileImageUrl
    };

  } 
  
  User.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson(){
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'type': type,
      'profileImageUrl': profileImageUrl
    };
  }
}
