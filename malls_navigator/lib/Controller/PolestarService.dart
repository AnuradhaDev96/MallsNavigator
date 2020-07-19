//Developed by
//IT17006408 - A.S.H. Siribaddana
//IT17076494 - De Silva P.H.N.N
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user.dart';
import '../Model/mall.dart';
import '../Model/favouriteMall.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

//Service class to access the firestore
class PolestarService {
  static final PolestarService _firestoreService = PolestarService._internal();
  final String userCollection = 'users';
  final String mallCollection = 'mall';
  final String favMallCollection = 'favouriteMall';
  Firestore _polestarDb = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  PolestarService._internal();

  factory PolestarService(){
    return _firestoreService;
  }

  //UserService methods
  //POST METHODS
  addUser(User user, File image) async{
    final StorageReference profileImageRef = _firebaseStorage.ref().child("Profile Images");  
    Uuid imageId = new Uuid();
    //imageId.v1();
    String saveAs = imageId.v1().toString() + extension(basename(image.path));
    final StorageUploadTask uploadTask = profileImageRef.child(saveAs).putFile(image); 
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();
    user.profileImageUrl = url;

    try{
      _polestarDb.runTransaction(
        (Transaction transaction) async {
          await _polestarDb.collection(userCollection).document().setData(user.toJson());
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET METHODS
  getUsers() {
    return _polestarDb.collection(userCollection).snapshots();
  }

  //UPDATE METHODS
  update(User user, String newName){
    try{
      _polestarDb.runTransaction(
        (Transaction transaction) async {
          await transaction.update(user.reference, {'userName': newName}); 
        }
      );
    }catch(e){
      print(e.toString());
    }
  } 

  //DELETE METHODS
  delete(User user){
    _polestarDb.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(user.reference);
      }
    );
  } 

  //SignUpServvice methods
  //PUT METHODS
  Future<String> signUp(User user, File image) async{
    final isesixt = await isUserExists(user.email);

    if(isesixt){      
      return "EXISTS";
    }
    else{
      addUser(user, image); 
      return "CREATED"; 
    }

  }

  //GET METHODS
  isUserExists(String email) async{
    final QuerySnapshot result = await _polestarDb.collection(userCollection).where('email', isEqualTo: email).limit(1).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //return (documents.length == 1);
    if (documents.length == 1){
      return true;
    }else{
      return false;
    }
  } 

  signIn(String email, String password) async{
    final QuerySnapshot result = await _polestarDb.collection(userCollection).where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
        
    if (documents.length == 1){
      User usr =User.fromSnapshot(documents[0]);
      return usr;
    }else{
      return null;
    }    
  } 



  //MallService methods
  //POST METHODS
  addMall(Mall mall){
    try{
      _polestarDb.runTransaction(
        (Transaction transaction) async {
          await _polestarDb.collection(mallCollection).document().setData(mall.toJson());
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //PUT METHODS
  updateMall(Mall existingMall, Mall newMall){
    try{
      _polestarDb.runTransaction(
        (Transaction transaction) async {
          //DocumentSnapshot snap =  await transaction.get(newMall.reference);
          await transaction.update(existingMall.reference, newMall.toMap());           
        }
      );
    }catch(e){
      print(e.toString());
    }
  }

  getSingleMall() async{
    final QuerySnapshot result = await _polestarDb.collection(userCollection).limit(1).getDocuments();
    return result;
  }

  //GET METHODS
  getMalls(){
    Stream<QuerySnapshot> malls = _polestarDb.collection(mallCollection).snapshots();
    return malls;
  }
  
  getMallsByMallName(String mallName){
    return _polestarDb.collection(mallCollection).where('name', isEqualTo: mallName).snapshots();
  }
  // getMallById(){
  //   return _db.collection(mallCollection)
  // }

  //DELETE METHODS
  deleteMall(Mall mall){
    _polestarDb.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(mall.reference);
      }
    );
  }

  //FavouriteMallsService methods
  //POST METHODS
  addFavouriteMall(FavouriteMall fav){
    try{
      _polestarDb.runTransaction(
        (Transaction transaction) async {
          await _polestarDb.collection(favMallCollection).document().setData(fav.toJson());
        }
      );
    } catch(e){
      print(e.toString());
    }
  }

  //GET METHODS
  getFavouriteMalls(DocumentReference userReference){
    return _polestarDb.collection(favMallCollection).where('userId', isEqualTo: userReference).snapshots();
  }

  getFavouriteMallsByMallName(String mallName, DocumentReference userReference){
    return _polestarDb.collection(favMallCollection).where('name', isEqualTo: mallName).where('userId', isEqualTo: userReference).snapshots();
  }

  //DELETE METHODS
  deleteFavouriteMall(FavouriteMall favouriteMall){
    _polestarDb.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(favouriteMall.reference);
      }
    );
  }

}



