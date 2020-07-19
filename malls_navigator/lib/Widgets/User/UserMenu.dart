// import 'package:flutter/material.dart';
// import 'UserMallList.dart';

// class UserMenu extends StatefulWidget {
//   UserMenu({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _UserMenuState createState() => _UserMenuState();
// }

// class _UserMenuState extends State<UserMenu> {
//       TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);

//   @override
//   Widget build(BuildContext context) {

//     final mainTitle = Container (
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: new Text(
//                 "User Dashboard",
//                 style: new TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),))
//           ],
//         ),
//       );


//     final subTitle = Container (
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: new Text(
//                 "Browse malls",
//                 style: new TextStyle(color: Colors.white, fontSize: 18.0),))
//           ],
//         ),
//       );

//     final userMallListViewButton = ButtonTheme(          
//       minWidth: MediaQuery.of(context).size.width,
//       child: new OutlineButton(            
//         //borderSide: Colors.blue[400], 
//         highlightColor: Colors.blue[400],
//         borderSide: BorderSide(style: BorderStyle.solid, color: Colors.blue[400]),            
//         child: Text(
//           "Malls",              
//           textAlign: TextAlign.center,
          
//           style: style.copyWith(color: Colors.blue[400], fontWeight: FontWeight.bold)),              
//         onPressed: (){
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => UserMallList(title: 'Malls Edit Console')),
//             );
//       },),
//     );

//     return Scaffold(
//       body: Center(
//         child: Container(
//           decoration: new BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.indigo[700], Colors.blue[400]],
//               begin: Alignment.centerRight,
//               end: Alignment(-1.0, 1.0),
//             )
//           ),
//           child: Padding(                
//             padding: const EdgeInsets.all(36.0),
//             child: Column(                  
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 5.0),
//                 mainTitle,
//                 SizedBox(height: 10.0),
//                 subTitle,
//                 SizedBox(
//                   height: 50.0,
//                 ),
//                 userMallListViewButton,
//                 SizedBox(
//                   height: 15.0,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
