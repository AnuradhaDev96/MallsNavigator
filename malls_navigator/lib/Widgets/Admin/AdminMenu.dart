//Developed by
//IT17076494 - De Silva P.H.N.N

import 'package:flutter/material.dart';
import 'AddMall.dart';
import 'AdminMallList.dart';
import 'AdminGroupedUserList.dart';
import 'package:url_launcher/url_launcher.dart';

//Included PageSocketBucket to show set of screens in single screen.
//Only screens of admin is shown here.
//Reference: 2020. [online] Available at: <https://www.youtube.com/watch?v=8YsO1FOLy5s> [Accessed 4 May 2020].
class AdminMenu extends StatefulWidget {
  AdminMenu({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AdminMenuState createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  int bottomTab = 0;
  Widget currentAdminScreen = AdminMallList();
  final PageStorageBucket screenBucket = PageStorageBucket();

  final List<Widget> adminScreens = [
    AddMall(),
    AdminMallList()
  ];  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentAdminScreen,
        bucket: screenBucket,
      ),    
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[600],
        onPressed: (){
          setState(() {
            currentAdminScreen = AddMall();
            bottomTab = 1;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                minWidth: 40.0,
                onPressed: (){
                  setState(() {
                    currentAdminScreen = AdminMallList();
                    bottomTab = 2;
                  });
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.view_list,
                      color: bottomTab == 2 ? Colors.indigo[600] : Colors.indigo[200],                      
                    ),
                    Text(
                      'Malls',
                      style: TextStyle(color: bottomTab == 2 ? Colors.indigo[600] : Colors.indigo[200])
                    )
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40.0,
                onPressed: () async {
                  setState(() {
                    //currentScreen = AddMall();
                    bottomTab = 3;
                  });
                  final mapUrl = 'https://www.google.com/maps/search/?api=1';
                  if (await canLaunch(mapUrl)){
                    await launch(mapUrl);
                  } else {
                    throw 'Could not load';
                  }
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.map,
                      color: bottomTab == 3 ? Colors.indigo[600] : Colors.indigo[200],                      
                    ),
                    Text(
                      'Google Map',
                      style: TextStyle(color: bottomTab == 3 ? Colors.indigo[600] : Colors.indigo[200])
                    )
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40.0,
                onPressed: () async {
                  // setState(() {
                  //   currentScreen = AddMall();
                  //   currentTab = 1;
                  // });                  
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: bottomTab == 4 ? Colors.indigo[600] : Colors.indigo[200],                      
                    ),
                    Text(
                      'My Profile',
                      style: TextStyle(color: bottomTab == 4 ? Colors.indigo[600] : Colors.indigo[200])
                    )
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 40.0,
                onPressed: () async {
                  setState(() {
                    currentAdminScreen = AdminGroupedUserList();
                    bottomTab = 5;
                  });                  
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: bottomTab == 5 ? Colors.indigo[600] : Colors.indigo[200],                      
                    ),
                    Text(
                      'Users',
                      style: TextStyle(color: bottomTab == 5 ? Colors.indigo[600] : Colors.indigo[200])
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
