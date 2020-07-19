//Developed by
//IT17076494 - De Silva P.H.N.N
import 'package:flutter/material.dart';
import 'package:malls_navigator/Widgets/User/UserMallList.dart';
import '../../Controller/PolestarService.dart';
import '../../Model/user.dart';
import '../Admin/AdminMenu.dart';
import 'SignUp.dart';

//SignIn screen => user logs into the application
class SignIn extends StatefulWidget {
      SignIn({Key key, this.title}) : super(key: key);
      final String title;
      @override
      _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
      //Controllers are defined to assign the values of TextFormfields
      static TextEditingController emailController = TextEditingController();
      static TextEditingController passwordController = TextEditingController();
      PolestarService _polestarService = PolestarService(); 
      final _formKey = GlobalKey<FormState>();      

      final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email", hintText: "malluser@gmail.com"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Passwords enter email to login';
          }
          return null;          
        },
      );

      final password = TextFormField(
        //key: _passKey,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: "Password", hintText: "Enter password"
        ),
        validator: (value){
          if (value.isEmpty){
            return 'Passwords enter email to login';
          }
          return null;          
        },
      );

      final guidlinesCard = Card(
        color: Colors.red[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning, size: 10),
              title: Text('Password should have'),
              subtitle: Text('1 Upper case\n1 Lower Case\n1 Numeric number\n1 special character\nCommon Allow Character(! @ # & * ~)'),
            ),
          ],
        ),
      );

      signIn() async{
        User result = await _polestarService.signIn(email.controller.text, password.controller.text);
        if(result == null){
          _invalidUserDialog();
        }else if (result.type == "user"){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserMallList(loggedInUser: result)),
          );
        }else if(result.type == "admin"){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminMenu()),
          );
        }
      }

      void _invalidUserDialog() {        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Invalid User!"),
              content: new Text("Incorrect username or password")
            );
          },
        );
      }

      signInButton() {
        return Container(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70.0)
            ),
            color: Colors.teal[400],
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white 
              ),
            ),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                signIn();
              }              
            }
          )
        );
      }

      signUpButton() {
        return SizedBox(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70.0)
            ),
            color: Colors.lightBlue[600],
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white 
              ),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
                );              
            }
          )
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(              
              child: Padding(                
                padding: EdgeInsets.only(top:100, bottom: 20.0, left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                   Container(
                     width: double.infinity,
                     height: 440,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10.0),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black26,
                           offset: Offset(0.0, 15.0),
                           blurRadius: 12.0,
                         )
                       ]
                     ),
                    child:Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Login", 
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 8.0 
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                email,
                                SizedBox(
                                  height: 10,
                                ),
                                password,
                                SizedBox(
                                  height: 20,
                                ),
                                signInButton(),
                                SizedBox(
                                  height: 25,
                                ),
                                Text("Don't have an Account?"),
                                signUpButton(),
                                SizedBox(
                                  height: 20
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                    )
                    )
                ],
                ),
              ),
            )
            ] 
          ),
        );
      }
    }