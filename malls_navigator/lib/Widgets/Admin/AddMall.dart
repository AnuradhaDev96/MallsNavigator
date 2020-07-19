//Developed by
//IT17076494 - De Silva P.H.N.N

import 'package:flutter/material.dart';
import '../../Controller/PolestarService.dart';
import '../../Model/mall.dart';

//Widget to add new mall
class AddMall extends StatefulWidget {
      AddMall({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _AddMallState createState() => _AddMallState();
}

class _AddMallState extends State<AddMall> {
      //Controllers are defined to assign the values of TextFormfields
      static TextEditingController nameController = TextEditingController();
      static TextEditingController descriptionController = TextEditingController();
      static TextEditingController longitudeController = TextEditingController();
      static TextEditingController latitudeController = TextEditingController();
      final _addMallScaffoldKey = GlobalKey<ScaffoldState>();
      PolestarService _polestarService = PolestarService();
      //_formKey is used to validate the textFormfields
      final _formKey = GlobalKey<FormState>();

      final mallName = TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: "Mall Name", hintText: "Enter mall name"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter mall name';
          }
          return null;
        },
      );

      final mallDescription = TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: "Description", hintText: "Enter description"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter description for mall';
          }
          return null;
        },
      );

      final longitude = TextFormField(
        controller: longitudeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Longitude", hintText: "Enter longitude"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter longitute of mall';
          }
          return null;
        },
      );

      final latitude = TextFormField(
        controller: latitudeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Latitude", hintText: "Enter latitude"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter latitude of mall';
          }
          return null;
        },
      );
         
      getUsers(){
        return _polestarService.getUsers();
      }

      addMall(){
        Mall mall = Mall(name: mallName.controller.text, description: mallDescription.controller.text, longitude: double.parse(longitude.controller.text), latitude: double.parse(latitude.controller.text));
        _polestarService.addMall(mall);
        setState(() {
          mallName.controller.text = "";
          mallDescription.controller.text = "";
          longitude.controller.text = "";
          latitude.controller.text = "";
        });
        _addMallScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Successfully added.'),
          backgroundColor: Colors.teal[900],
        ));
      }

      addMallButton() {
        return SizedBox(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70.0)
            ),
            color: Colors.orange[400],
            child: Text(
              "Add Shopping Mall",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white 
              ),
            ),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                addMall();
              }               
            }
          ),
        );
      }
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          key: _addMallScaffoldKey,
          appBar: AppBar(
            elevation: 5.0,
            title: Text("Add Mall"),
            backgroundColor: Colors.indigo[600],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[              
              SingleChildScrollView( 
              child: Padding(                
                //padding: EdgeInsets.all(5.0),
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
                        "assets/addMall.png",
                        height: 100.0,
                        width: 200.0,
                      ),)
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
                          height: 15.0,
                        ),
                        addMallButton(),
                      ],
                    ))
                  ],
            )
              )
              )
            ]
            
          ),
        );
      }
    }