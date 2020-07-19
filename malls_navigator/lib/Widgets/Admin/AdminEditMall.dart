//Developed by
//IT17076494 - De Silva P.H.N.N

import 'package:flutter/material.dart';
import '../../Controller/PolestarService.dart';
import '../../Model/mall.dart';
import 'AdminMallList.dart';

//Widget to edit a mall selected from the AdminMallList
class AdminEditMall extends StatefulWidget {
  AdminEditMall({Key key, this.mall}) : super(key: key);
  final Mall mall;
  @override
  _AdminEditMallState createState() => _AdminEditMallState();
}

class _AdminEditMallState extends State<AdminEditMall> {
  static Mall _mall;
  PolestarService _polestartService = PolestarService();
  static TextEditingController nameController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController longitudeController = TextEditingController();
  static TextEditingController latitudeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _editMallScaffoldKey = GlobalKey<ScaffoldState>();  

  @override
  void initState() {
    _mall= widget.mall;
    mallName.controller.text = _mall.name;
    mallDescription.controller.text = _mall.description;
    latitude.controller.text = _mall.latitude.toString();
    longitude.controller.text = _mall.longitude.toString();
    super.initState();
  }

  static final mallName = TextFormField(
    controller: nameController,
    //initialValue: _mall.name.toString(),
    decoration: InputDecoration(
      labelText: "Mall Name", hintText: "Enter mall name"
    ),
    validator: (value){
      if (value.isEmpty && mallName.controller.text == ""){
        return 'Please enter mall name';
      }
      return null;
    },
  );

  static final mallDescription = TextFormField(
    controller: descriptionController,
    decoration: InputDecoration(
      labelText: "Description", hintText: "Enter description"
    ),
    validator: (value){
      if (value.isEmpty && mallDescription.controller.text == ""){
        return 'Please enter description for mall';
      }
      return null;
    },
  );

  static final longitude = TextFormField(
    controller: longitudeController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "Longitude", hintText: "Enter longitude"
    ),
    validator: (value){
      if (value.isEmpty && longitude.controller.text == ""){
        return 'Please enter longitute of mall';
      }
      return null;
    },
  );

  static final latitude = TextFormField(
    controller: latitudeController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: "Latitude", hintText: "Enter latitude"
    ),
    validator: (value){
      if (value.isEmpty && latitude.controller.text == ""){
        return 'Please enter latitude of mall';
      }
      return null;
    },
  );  

  updateMall(){
    Mall newMall = Mall(name: mallName.controller.text, description: mallDescription.controller.text, longitude: double.parse(longitude.controller.text), latitude: double.parse(latitude.controller.text));
    _polestartService.updateMall(_mall, newMall);
    _editMallScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Shopping mall edited successfully.'),
      backgroundColor: Colors.lime[700],
      action: SnackBarAction(
        label: 'Done', 
        onPressed: (){
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => AdminMallList()),
            );
        }
      ),
    ));    
  }

  deleteMall(){
    _polestartService.deleteMall(_mall);
    Navigator.pop(
    context,
    MaterialPageRoute(builder: (context) => AdminMallList()),
    );
  }

  saveChangesbutton() {
    TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 15.0, color: Colors.white);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70.0)
        ),
        color: Colors.teal[300],
        child: Text(
          "Save Changes",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white 
          ),
        ),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            updateMall();
          }              
        }
      )
    );
  }

  deleteMallbutton() {
    TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 15.0, color: Colors.white);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70.0)
        ),
        color: Colors.deepOrange[400],
        child: Text(
          "Delete",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white 
          ),
        ),
        onPressed: (){
          deleteMall();                        
        }
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _editMallScaffoldKey,
      appBar: AppBar(
        title: Text('Edit Mall'),
        backgroundColor: Colors.indigo[600],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top:10, bottom: 20.0, left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150.0,
                        width: 200.0,
                        child: Image.asset(
                        "assets/alert.png",
                        height: 100.0,
                        width: 200.0,
                      ),
                      )
                      
                    ],
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          mallName,
                          mallDescription,
                          latitude,
                          longitude,
                          SizedBox(
                            height: 10
                          ),
                          saveChangesbutton(),
                          deleteMallbutton(),
                          SizedBox(
                            height: 20
                          ),
                        ],
                      )
                    )
                  
                ]
              )
            )
          )
        ] 
      )
    );
  }
}