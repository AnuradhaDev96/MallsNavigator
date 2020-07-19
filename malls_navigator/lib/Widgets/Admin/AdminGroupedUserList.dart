//Developed by
//IT17006408 - A.S.H.Siribaddana

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Controller/PolestarService.dart';
import '../../Model/user.dart';

//Widget to show the users registered in the application
//View is only available for admin
class AdminGroupedUserList extends StatefulWidget {
      AdminGroupedUserList({Key key}) : super(key: key);
      @override
      _AdminGroupedUserListState createState() => _AdminGroupedUserListState();
}

class _AdminGroupedUserListState extends State<AdminGroupedUserList> {
  static PolestarService _polestarService = PolestarService();
  static Stream<QuerySnapshot> userList;

  @override
  void initState() {
    userList = _polestarService.getUsers();
    super.initState();
  }

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: userList,
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          //print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data){
    final user = User.fromSnapshot(data);
    return Card(
      color: Colors.black54,
      elevation: 5.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.profileImageUrl),           
        ),              
        title: Text(
          user.fullName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold            
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            color: Colors.orange[400],
            fontSize: 15,           
        )
        ),        
        trailing: (user.type == "admin") ? CircleAvatar(backgroundImage: AssetImage('assets/adminIcon.png'),backgroundColor: Colors.white,) : CircleAvatar(backgroundImage: AssetImage('assets/userIcon.png')), 
        onTap: (){
          
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Polestar Users'),
      backgroundColor: Colors.indigo[600],
    ),
    body: Container(
      color: Colors.indigo[300],
      padding: EdgeInsets.all(5.0),
      child: Padding(              
        padding: const EdgeInsets.all(5.0),
        child: Column(                
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: buildBody(context)
            )
          ],
        ),
      ),
    ),
  );
    //);
  }
}