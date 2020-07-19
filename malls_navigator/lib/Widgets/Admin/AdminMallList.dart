//Developed by
//IT17076494 - De Silva P.H.N.N
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/mall.dart';
import '../../Controller/PolestarService.dart';
import '../Map/MallLocatorMap.dart';
import 'AdminEditMall.dart';

//Widget to display mall and manage them by admin
class AdminMallList extends StatefulWidget {
      AdminMallList({Key key}) : super(key: key);
      @override
      _AdminMallListState createState() => _AdminMallListState();
}

class _AdminMallListState extends State<AdminMallList> {
  static PolestarService _polestarService = PolestarService();
  TextStyle mallHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static TextEditingController searchBarController = TextEditingController();
  static Stream<QuerySnapshot> mallList;

  @override
  void initState() {
    mallList = _polestarService.getMalls();
    super.initState();
  }

  void getMalls(String mallName) async{
    if(mallName == "ALL"){
      setState(() {
        mallList = null;
        mallList = _polestarService.getMalls();
        searchBarController.text = "";
      });
      //return api.getMalls();
    }else{
      setState(() {
        mallList = null;
        mallList = _polestarService.getMallsByMallName(mallName);
      });
    }
  }

  deleteMall(Mall mall){
    _polestarService.deleteMall(mall);
  }

  Widget shoppingMalSearchBar(BuildContext context){
    return TextField(
      onEditingComplete: (){
        setState(() {
          mallList = null;
          getMalls(searchBarController.text);
        });
      },
      cursorColor: Colors.green,
      textInputAction: TextInputAction.search,
      controller: searchBarController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search Mall Here",
        prefixIcon: IconButton(
          splashColor: Colors.blue,
          iconSize: 20.0,
          icon: Icon(Icons.search),
          onPressed: () {
            getMalls(searchBarController.text);
            },
        ),
        suffixIcon: IconButton(
          tooltip: "Clear Search",
          splashColor: Colors.blue,
          iconSize: 20.0,
          icon: Icon(Icons.clear),
          onPressed: () {
            getMalls("ALL");
            },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        )
      ),
    );
  }

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: mallList,
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

  void _manageMallDialog(Mall mall) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          elevation: 200,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            color: Colors.indigo[600]
          ),
          title: new Text("Manage Shopping Mall"),
          content: new Text(
            "You may edit or delete this shopping mall.",
            style: TextStyle(
              fontSize: 15.0
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              color: Colors.grey[200],
              child: new Text(
                "Edit",
                style: TextStyle(
                  color: Colors.indigo[600]
                ),
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminEditMall(mall: mall)),
                );

              },
            ),
            new FlatButton(
              color: Colors.red,
              child: new Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white
                )
              ),
              onPressed: () {
                deleteMall(mall);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data){
    final mall = Mall.fromSnapshot(data);
    return Card(
      borderOnForeground: true,
      color: Colors.indigo,
      elevation: 5.0,
      child: ListTile(
        title: Text(
          mall.name,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          )
        ),
        subtitle: Text(
          mall.description,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
            fontWeight: FontWeight.normal
          )
        ),
        trailing: Icon(
          Icons.touch_app,
          color: Colors.grey[300],
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MallLocatorMap(title: 'Malls Edit Console', latitude: mall.latitude, longitude: mall.longitude, locationName: mall.name)),
          );
        },
        onLongPress: (){
          _manageMallDialog(mall);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Mall Console'),
        backgroundColor: Colors.indigo[600],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              shoppingMalSearchBar(context),
              SizedBox(
                height:5.0
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_on, size: 12.0,),
                  Text(
                    "  Tap to view location on Polestar Map",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.green[600]
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.edit, size: 12.0,),
                  Text(
                    "  Tap and hold to manage mall",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.orange[600]
                    ),
                  )
                ],
              ),
              Flexible(
                    child: buildBody(context)
                  )
            ],
          ),
        ),
      ),
    );
  }
}