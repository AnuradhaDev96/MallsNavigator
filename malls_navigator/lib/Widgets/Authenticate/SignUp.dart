//Developed by
//IT17006408 - A.S.H. Siribaddana
import 'package:flutter/material.dart';
import 'package:malls_navigator/Widgets/Authenticate/SignIn.dart';
import '../../Controller/PolestarService.dart';
import '../../Model/user.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//User registers into Polestar using this
class SignUp extends StatefulWidget {
      SignUp({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
      static TextEditingController fullNameController = TextEditingController();
      static TextEditingController emailController = TextEditingController();
      static TextEditingController passwordController = TextEditingController();
      static TextEditingController confirmPasswordController = TextEditingController();
      static File profileImageFile;
      final _formKey = GlobalKey<FormState>(); 
      final _scaffoldKey = GlobalKey<ScaffoldState>();
      PolestarService _polestarService = PolestarService();

      final fullName = TextFormField(
        controller: fullNameController,        
        decoration: InputDecoration(
          labelText: "Full Name", hintText: "Enter full name"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Please enter full name';
          }
          return null;
        },
      );

      final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email", hintText: "malluser@gmail.com"
        ),
        validator: validateEmailAddress,
      );

      static String validateEmailAddress(String value) {
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please enter valid email';
        else
          return null;
      }

      final password = TextFormField(
        //key: _passKey,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: "Password", 
          hintText: "Enter password",
          helperText: '1 Upper case\n1 Lower Case\n1 Numeric number\n1 special character\nCommon Allow Character(! @ # & * ~)',
        ),
        validator: validatePassword,
      );

      static String validatePassword(String value) {
        Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please follow password guidlines';
        else
          return null;
      }

      final confirmPassword = TextFormField(
        controller: confirmPasswordController,
        decoration: InputDecoration(
          labelText: "Confirm Password", hintText: "Confirm password"
        ),
        validator: (value){
          if (value != passwordController.text){
            return 'Passwords does not match';
          }
          return null;          
        },
      );
      
      signUp() async{
        if(profileImageFile == null){
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Profile picture is not selected.'),
            ));
            return;
        }
        User newUser = User(fullName: fullName.controller.text, email: email.controller.text, password: password.controller.text, type: "user", profileImageUrl: "");        
        String result = await _polestarService.signUp(newUser, profileImageFile);
        if (result == "EXISTS"){
          _userAlreadyExistsDialog();
        }else{
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Registered Successfully'),              
              action: SnackBarAction(
                label: 'Sign In', 
                onPressed: (){
                  Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                  ); 
                }
              ),
            ));
            setState(() {
              fullName.controller.text = "";
              email.controller.text = "";
              password.controller.text = "";
              confirmPassword.controller.text = "";
              profileImageFile = null;
            });
        }
        
      }

      void _userAlreadyExistsDialog() {      
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Already Exists!"),
              content: new Text("This email already has an Account.\nPlease Re-enter a new email."),
            );
          },
        );
      }

      signUpButton() {
        return SizedBox(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70.0)
            ),
            color: Colors.teal[400],
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white 
              ),
            ),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                signUp();
              }               
            }
          ),
          );
      }

      Future getProfileImage(BuildContext context) async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          profileImageFile = image;
        }
        );
        _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Image selected'),
              action: SnackBarAction(
                label: 'Undo', 
                onPressed: (){
                  // setState(() {
                  //   profileImageFile = null;
                  // });
                }
              ),
            ));
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Sign Up"),
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
                      Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.indigo[600],
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 110.0,
                                      height: 110.0,
                                      child: (profileImageFile != null)?Image.file(profileImageFile, fit: BoxFit.fill)
                                      :Image.asset('assets/user.png',fit: BoxFit.fill)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:60.0),
                                child: FloatingActionButton(                                  
                                  onPressed: (){
                                    getProfileImage(context);
                                  },                                  
                                  shape: CircleBorder(),
                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                  backgroundColor: Colors.indigo[100],
                                  child: const Icon(Icons.camera_alt, size: 20.0, color: Colors.white,),
                                  tooltip: 'Upload picture',
                                ),
                              ),
                            ],
                          ),
                          fullName,
                          email,                              
                          password,
                          confirmPassword,
                          signUpButton(),
                        ],
                      ))
                    ]
                  )
                )
              )
          ],)
        );
      }
    }